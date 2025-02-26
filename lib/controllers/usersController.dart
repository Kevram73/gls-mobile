import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gls/helpers/launchReq.dart';
import 'package:gls/helpers/urls.dart';
import 'package:gls/models/journal.dart';
import 'package:gls/models/type_user.dart';
import 'package:gls/models/user.dart';
import 'package:gls/models/vente.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class UsersController extends GetxController {
  final storage = GetStorage();
  final RxList<User> users = <User>[].obs;
  final RxList<Journal> journals = <Journal>[].obs;
  final RxList<User> commerciaux = <User>[].obs;
  final LaunchReq apiClient = LaunchReq();
  final RxList<Vente> ventes = <Vente>[].obs;

  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxList<TypeUser> typeUsers = <TypeUser>[].obs;

  @override
  void onInit() {
    fetchUsers();
    fetchTypeUsers();
    fetchJournals();
    super.onInit();
  }

  Map<String, String> _authHeaders() {
    String? token = storage.read("token");
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  /// 📥 **Fetch Users from API**
  Future<void> fetchUsers() async {
    isLoading.value = true;
    final response = await apiClient.getRequest(Urls.usersListUrl, headers: _authHeaders());
    isLoading.value = false;

    if (response != null && response is List) {
      users.assignAll(response.map((json) => User.fromJson(json)).toList());
    } else {
      _showToast(response?["message"] ?? "Erreur lors du chargement des utilisateurs", error: true);
    }
  }

  Future<void> fetchJournals() async {
    isLoading.value = true;
    final response = await apiClient.getRequest(Urls.journalsListUrl, headers: _authHeaders());
    isLoading.value = false;

    if (response != null && response is List) {
      journals.assignAll(response.map((json) => Journal.fromJson(json)).toList());
    } else {
      _showToast(response?["message"] ?? "Erreur lors du chargement des utilisateurs", error: true);
    }
  }

  Future<void> fetchUserVentes(int id) async {
    isLoading.value = true;
    final response = await apiClient.getRequest(Urls.ventesBySellerUrl.replaceFirst("{sellerId}", id.toString()), headers: _authHeaders());
    isLoading.value = false;

    if (response != null && response is List) {
      ventes.assignAll(response.map((json) => Vente.fromJson(json)).toList());
    } else {
      _showToast(response?["message"] ?? "Erreur lors du chargement des ventes", error: true);
    }
  }

  Future<void> fetchCommerciaux() async {
    isLoading.value = true;
    final response = await apiClient.getRequest('${Urls.usersListWithTypeUrl}/3', headers: _authHeaders());
    isLoading.value = false;
    log("$response");

    if (response != null && response is List) {
      commerciaux.assignAll(response.map((json) => User.fromJson(json)).toList());
    } else {
      _showToast(response?["message"] ?? "Erreur lors du chargement des utilisateurs", error: true);
    }
  }

  Future<void> fetchTypeUsers() async {
    isLoading.value = true;
    final response = await apiClient.getRequest(Urls.typeUsersListUrl, headers: _authHeaders());
    isLoading.value = false;

    if (response != null && response is List) {
      typeUsers.assignAll(response.map((json) => TypeUser.fromJson(json)).toList());
    } else {
      _showToast(response?["message"] ?? "Erreur lors du chargement des types d'utilisateur", error: true);
    }
  }

  List<User> filteredUsersByType(int typeUserId) {
    return users.where((user) {
      return user.typeUserId == typeUserId &&
          (user.nom!.toLowerCase().contains(searchQuery.value) ||
           user.prenom!.toLowerCase().contains(searchQuery.value) ||
           user.email!.toLowerCase().contains(searchQuery.value));
    }).toList();
  }

  /// ➕ **Add a User**
  Future<void> addUser(String nom, String prenom, String email, String numPhone, int typeUserId) async {
    final response = await apiClient.postRequest(Urls.usersListUrl, {
      "nom": nom,
      "prenom": prenom,
      "email": email,
      "num_phone": numPhone,
      "type_user_id": typeUserId,
    }, headers: _authHeaders());

    log("$response");

    if (response != null && response["error"] == null) {
      users.add(User.fromJson(response));
      _showToast(response["message"] ?? "Utilisateur ajouté avec succès");
    } else {
      _showToast(response?["message"] ?? "Impossible d'ajouter l'utilisateur", error: true);
    }
  }

  /// 📝 **Update a User**
  Future<void> updateUser(int id, String nom, String prenom, String email, String numPhone, int typeUserId) async {
    final response = await apiClient.putRequest(Urls.updateUserUrl.replaceFirst("{id}", id.toString()), {
      "nom": nom,
      "prenom": prenom,
      "email": email,
      "num_phone": numPhone,
      "type_user_id": typeUserId,
    }, headers: _authHeaders());

    if (response != null && response["error"] == null) {
      int index = users.indexWhere((user) => user.id == id);
      if (index != -1) {
        users[index] = User.fromJson(response);
        _showToast(response["message"] ?? "Utilisateur mis à jour avec succès");
      }
    } else {
      _showToast(response?["message"] ?? "Erreur lors de la mise à jour", error: true);
    }
  }

  /// ❌ **Delete a User**
  Future<void> deleteUser(int id) async {
    final response = await apiClient.deleteRequest(Urls.deleteUserUrl.replaceFirst("{id}", id.toString()), headers: _authHeaders());

    if (response != null && response["error"] == null) {
      users.removeWhere((user) => user.id == id);
      _showToast(response["message"] ?? "Utilisateur supprimé avec succès");
    } else {
      _showToast(response?["message"] ?? "Erreur lors de la suppression", error: true);
    }
  }

  /// 🔍 **Filter Users Based on Search Query**
  List<User> get filteredUsers {
    return users.where((user) {
      return user.nom!.toLowerCase().contains(searchQuery.value) ||
             user.prenom!.toLowerCase().contains(searchQuery.value) ||
             user.email!.toLowerCase().contains(searchQuery.value);
    }).toList();
  }

  /// 📄 **Export Commerciaux List to PDF**
  Future<void> exportCommerciauxToPdf() async {
    try {
      await fetchCommerciaux();
      await Printing.info(); // Ensure the plugin is initialized
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.ListView.builder(
              itemCount: commerciaux.length,
              itemBuilder: (context, index) {
                final user = commerciaux[index];
                return pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Nom: ${user.nom} ${user.prenom}", style: pw.TextStyle(fontSize: 12)),
                      pw.Text("Email: ${user.email}", style: pw.TextStyle(fontSize: 12)),
                      pw.Text("Téléphone: ${user.numPhone}", style: pw.TextStyle(fontSize: 12)),
                      pw.Text("Actif: ${user.actif}", style: pw.TextStyle(fontSize: 12)),
                      pw.Text("Créé le: ${user.createdAt?.toIso8601String()}", style: pw.TextStyle(fontSize: 12)),
                      pw.Divider(),
                    ],
                  ),
                );
              },
            );
          },
        ),
      );

      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
    } catch (e) {
      log("Erreur lors de l'exportation PDF: $e");
      _showToast("Erreur lors de l'exportation PDF", error: true);
    }
  }

  /// 🍞 **Show Toast Message**
  void _showToast(String message, {bool error = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: error ? const Color(0xFFD32F2F) : const Color(0xFF4CAF50),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
