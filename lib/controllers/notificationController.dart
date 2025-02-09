import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gls/models/notification.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  final storage = GetStorage();
  final String storageKey = 'notifications';

  @override
  void onInit() {
    super.onInit();
    loadNotifications(); // Charger les notifications au démarrage
  }

  // Charger les notifications depuis GetStorage
  void loadNotifications() {
    List<dynamic>? storedNotifications = storage.read<List<dynamic>>(storageKey);
    if (storedNotifications != null) {
      notifications.value = storedNotifications.map((json) => NotificationModel.fromJson(json)).toList();
    }
  }

  // Sauvegarder les notifications dans GetStorage
  void saveNotifications() {
    storage.write(storageKey, notifications.map((notif) => notif.toJson()).toList());
  }

  // Ajouter une notification
  void addNotification(String title, String description) {
    notifications.add(NotificationModel(
      title: title,
      description: description,
      date: DateTime.now(),
    ));
    saveNotifications(); // Sauvegarder après ajout
  }

  // Modifier une notification
  void editNotification(int index, String newTitle, String newDescription) {
    notifications[index] = NotificationModel(
      title: newTitle,
      description: newDescription,
      date: notifications[index].date, // Garde la date originale
    );
    saveNotifications(); // Sauvegarder après modification
  }

  // Supprimer une notification
  void deleteNotification(int index) {
    notifications.removeAt(index);
    saveNotifications(); // Sauvegarder après suppression
  }

  // Supprimer toutes les notifications
  void clearAllNotifications() {
    notifications.clear();
    storage.remove(storageKey); // Supprime du stockage
  }

  // Récupérer une date formatée
  
}
