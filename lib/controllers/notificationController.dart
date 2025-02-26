import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gls/helpers/launchReq.dart';
import 'package:gls/helpers/urls.dart';
import 'package:gls/models/notification.dart';

class NotificationController extends GetxController {
  final LaunchReq apiClient = LaunchReq();
  final GetStorage storage = GetStorage();

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final String storageKey = 'notifications';

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
    fetchNotifications();
  }

  Map<String, String> _authHeaders() {
    String? token = storage.read("token");
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    final response = await apiClient.getRequest(Urls.notificationsListUrl, headers: _authHeaders());
    isLoading.value = false;
    log(response.toString());

    if (response != null && response is List) {
      notifications.assignAll(response.map((json) => NotificationModel.fromJson(json)).toList());
    } else {
      _showToast(response?["message"] ?? "Erreur lors du chargement des notifications", error: true);
    }
  }

  void loadNotifications() {
    List<dynamic>? storedNotifications = storage.read<List<dynamic>>(storageKey);
    if (storedNotifications != null) {
      notifications.assignAll(storedNotifications.map((json) => NotificationModel.fromJson(json)).toList());
    }
  }

  void saveNotifications() {
    storage.write(storageKey, notifications.map((notif) => notif.toJson()).toList());
  }

  Future<void> addNotification(String title, String content) async {
    final newNotification = NotificationModel(
      title: title,
      content: content,
    );

    final response = await apiClient.postRequest(Urls.notificationsListUrl, newNotification.toJson(), headers: _authHeaders());

    if (response != null && response["error"] == null) {
      notifications.add(NotificationModel.fromJson(response));
      saveNotifications();
      _showToast(response["message"] ?? "Notification ajoutée avec succès");
    } else {
      _showToast(response?["message"] ?? "Impossible d'ajouter la notification", error: true);
    }
  }

  Future<void> editNotification(int index, String newTitle, String newDescription) async {
    final updatedNotification = NotificationModel(
      title: newTitle,
      content: newDescription,
    );

    final response = await apiClient.putRequest(
      Urls.notificationByIdUrl.replaceFirst("{id}", notifications[index].id.toString()),
      updatedNotification.toJson(),
      headers: _authHeaders(),
    );

    if (response != null && response["error"] == null) {
      notifications[index] = NotificationModel.fromJson(response);
      saveNotifications();
      _showToast(response["message"] ?? "Notification mise à jour");
    } else {
      _showToast(response?["message"] ?? "Échec de la mise à jour", error: true);
    }
  }

  Future<void> deleteNotification(int index) async {
    final response = await apiClient.deleteRequest(
      Urls.deleteNotificationUrl.replaceFirst("{id}", notifications[index].id.toString()),
      headers: _authHeaders(),
    );

    if (response != null && response["error"] == null) {
      notifications.removeAt(index);
      saveNotifications();
      _showToast(response["message"] ?? "Notification supprimée");
    } else {
      _showToast(response?["message"] ?? "Impossible de supprimer la notification", error: true);
    }
  }

  void clearAllNotifications() {
    notifications.clear();
    storage.remove(storageKey);
    _showToast("Toutes les notifications ont été supprimées");
  }

  String formattedDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }

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
