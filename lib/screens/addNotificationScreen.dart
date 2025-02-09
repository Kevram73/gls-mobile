import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/notificationController.dart';
import 'package:gls/helpers/coloors.dart';

class AddNotificationScreen extends StatelessWidget {
  final NotificationController controller = Get.find<NotificationController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  AddNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter Notification", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(titleController, "Titre"),
            const SizedBox(height: 15),
            _buildTextField(descriptionController, "Description", maxLines: 3),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Coloors.primaryColor),
                onPressed: _addNotification,
                child: const Text("Ajouter", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _addNotification() {
    if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
      controller.addNotification(titleController.text, descriptionController.text);
      Get.back();
    } else {
      Get.snackbar("Erreur", "Veuillez remplir tous les champs", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
