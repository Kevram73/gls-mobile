import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationModel {
  String title;
  String description;
  bool isRead;

  NotificationModel({required this.title, required this.description, this.isRead = false});
}

class NotificationAdminScreen extends StatefulWidget {
  @override
  _NotificationAdminScreenState createState() => _NotificationAdminScreenState();
}

class _NotificationAdminScreenState extends State<NotificationAdminScreen> {
  int selectedTab = 0; // 0 = Tout, 1 = Non lus, 2 = Lus

  List<NotificationModel> notifications = [
    NotificationModel(title: "Nouvelle annonce", description: "Un message important a été publié.", isRead: false),
    NotificationModel(title: "Réponse à votre plainte", description: "Votre plainte a reçu une réponse.", isRead: false),
    NotificationModel(title: "Nouveau client ajouté", description: "Un client potentiel vous a été assigné.", isRead: true),
    NotificationModel(title: "Défi hebdomadaire", description: "Atteignez 10 ventes cette semaine.", isRead: true),
    NotificationModel(title: "Alerte de rappel", description: "N'oubliez pas de répondre aux messages non lus.", isRead: true),
  ];

  List<NotificationModel> get filteredNotifications {
    if (selectedTab == 0) return notifications;
    if (selectedTab == 1) return notifications.where((n) => !n.isRead).toList();
    return notifications.where((n) => n.isRead).toList();
  }

  void markAsRead(NotificationModel notification) {
    setState(() {
      notification.isRead = true;
    });
  }

  void markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: markAllAsRead,
            child: const Text("Tout marquer comme lu", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(child: _buildNotificationList()),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTabButton("Tout", 0),
        _buildTabButton("Non lus", 1),
        _buildTabButton("Lus", 2),
      ],
    );
  }

  Widget _buildTabButton(String label, int index) {
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        decoration: BoxDecoration(
          color: selectedTab == index ? Colors.green[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selectedTab == index ? Colors.green[800] : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        return _buildNotificationTile(notification);
      },
    );
  }

  Widget _buildNotificationTile(NotificationModel notification) {
    return GestureDetector(
      onTap: () => markAsRead(notification),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: notification.isRead ? Colors.grey[300]! : Colors.green),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(FontAwesomeIcons.solidCircle, size: 10, color: notification.isRead ? Colors.transparent : Colors.green),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(notification.description, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
