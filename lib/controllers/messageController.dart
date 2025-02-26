import 'dart:convert';

import 'package:get/get.dart';
import 'package:gls/helpers/launchReq.dart';
import 'package:gls/helpers/urls.dart';
import 'package:gls/models/message.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:developer';

import 'package:gls/models/user.dart';

class MessageController extends GetxController {
  final RxList<Message> messages = <Message>[].obs;
  final RxBool isLoading = false.obs;
  final GetStorage storage = GetStorage();
  final LaunchReq apiClient = LaunchReq();
  var contactedUsers = <User>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  onInit(){
    super.onInit();
    usersAlreadyContacted();
  }

  Map<String, String> _authHeaders() {
    String? token = storage.read("token");
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<void> usersAlreadyContacted() async {
    isLoading.value = true;
    final response = await apiClient.getRequest(
      Urls.contactedUsersUrl,
      headers: _authHeaders(),
    );
    isLoading.value = false;
    log("$response");

    if (response != null && response is Map && response.containsKey("contacted_users")) {
      contactedUsers.assignAll(
        (response["contacted_users"] as List)
            .map((json) => User.fromJson(json))
            .toList(),
      );
    } else {
      contactedUsers.value = [];
    }
}


  List<User> get filteredUsers {
    return contactedUsers.where((user) {
      return user.nom!.toLowerCase().contains(searchQuery.value) ||
             user.prenom!.toLowerCase().contains(searchQuery.value) ||
             user.email!.toLowerCase().contains(searchQuery.value);
    }).toList();
  }

Future<void> fetchMessages(int otherUserId) async {
  try {
    isLoading.value = true;
    final responseRaw = await apiClient.getRequest(
      Urls.conversationMessagesUrl(otherUserId),
      headers: _authHeaders(),
    );
    isLoading.value = false;

    log("Raw response: $responseRaw");

    // Décodage de la réponse s'il s'agit d'une chaîne JSON
    Map<String, dynamic> response;
    if (responseRaw is String) {
      response = jsonDecode(responseRaw);
    } else if (responseRaw is Map<String, dynamic>) {
      response = responseRaw;
    } else {
      log("Type de réponse inattendu: ${responseRaw.runtimeType}");
      return;
    }

    // Vérifie que la réponse contient la clé "messages"
    if (response.containsKey("messages")) {
      final messagesField = response["messages"];

      if (messagesField is List) {
        // Structure directe : "messages": [ { ... }, { ... } ]
        messages.assignAll(
          messagesField.map((json) {
            final msg = Message.fromJson(json);
            msg.isMe = msg.senderId == storage.read("user_id");
            return msg;
          }).toList(),
        );
        log("Nombre de messages récupérés: ${messages.length}");
      } else if (messagesField is Map && messagesField.containsKey("data")) {
        // Structure paginée : "messages": { "data": [ { ... }, { ... } ], ... }
        final data = messagesField["data"];
        if (data is List) {
          messages.assignAll(
            data.map((json) {
              final msg = Message.fromJson(json);
              msg.isMe = msg.senderId == storage.read("user_id");
              return msg;
            }).toList(),
          );
          log("Nombre de messages récupérés: ${messages.length}");
        } else {
          log("⚠️ Erreur: 'data' n'est pas une liste (type ${data.runtimeType})");
        }
      } else {
        log("⚠️ Erreur: Format inattendu pour 'messages' (${messagesField.runtimeType})");
      }
    } else {
      log("⚠️ Erreur: Clé 'messages' introuvable dans la réponse");
    }
  } catch (e) {
    isLoading.value = false;
    log("❌ Erreur fetchMessages: $e");
  }
}

  /// Envoyer un message à un utilisateur (one-to‑one)
  Future<void> sendMessage(int receiverId, String content, {String? file}) async {
    try {
      final response = await apiClient.postRequest(
        Urls.sendMessageUrl,
        {
          "receiver_id": receiverId,
          "content": content,
          if (file != null) "file": file,
          "date_sent": DateTime.now().toIso8601String(),
          "time_sent": DateTime.now().toIso8601String(),
        },
        headers: _authHeaders(),
      );
      log("$response");

      if (response != null && response["error"] == null) {
        final Message newMessage = Message.fromJson(response);
        newMessage.isMe = true;
        messages.add(newMessage);
      } else {
        log("⚠️ Erreur: Impossible d'envoyer le message");
      }
    } catch (e) {
      log("❌ Erreur sendMessage: $e");
    }
  }

  /// Supprimer un message envoyé par l'utilisateur
  Future<void> deleteMessage(int messageId) async {
    try {
      final response = await apiClient.deleteRequest(
        Urls.deleteMessageUrl(messageId),
        headers: _authHeaders(),
      );

      if (response != null && response["error"] == null) {
        messages.removeWhere((message) => message.id == messageId);
      } else {
        log("⚠️ Erreur: Échec de la suppression du message");
      }
    } catch (e) {
      log("❌ Erreur deleteMessage: $e");
    }
  }
}
