import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/dashboardController.dart';
import 'package:gls/controllers/notificationController.dart';
import 'package:gls/models/notification.dart';
import 'package:gls/screens/addNotificationScreen.dart';


class NotificationListScreen extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());
  final DashboardController dashboardController = Get.find<DashboardController>();
  NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [

          dashboardController.user.value?.typeUserId! == 1? TextButton(
            onPressed: () => Get.to(() => AddNotificationScreen()),
            child: const Text("Ajouter", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ):Container()
        ],
      ),
      body: Obx(() => controller.notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                final notif = controller.notifications[index];
                return _buildNotificationTile(notif);
              },
            )),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text("Aucune notification", style: TextStyle(fontSize: 18, color: Colors.black54)),
    );
  }

  Widget _buildNotificationTile(NotificationModel notif) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(notif.title!, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notif.content!),
            const SizedBox(height: 5),
            // Text(
            //   "${notif.date.day}/${notif.date.month}/${notif.date.year} - ${notif.date.hour}:${notif.date.minute}",
            //   style: const TextStyle(fontSize: 12, color: Colors.grey),
            // ),
          ],
        ),
      ),
    );
  }
}
