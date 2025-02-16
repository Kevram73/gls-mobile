import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/dashboardController.dart';
import 'package:gls/screens/changePasswordScreen.dart';
import 'package:image_picker/image_picker.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String profileType = "Admin"; // Exemple de profil
  String userName = "Jane Coper";
  XFile? _imageFile; // Image sélectionnée
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }
  final DashboardController controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfileHeader("${controller.user.value!.nom} ${controller.user.value!.prenom}", "${controller.user.value!.typeUserId}"),
            const SizedBox(height: 20),
            _buildSectionTitle("Options"),
            const SizedBox(height: 10),
            _buildSettingOption(Icons.lock, "Changer le mot de passe", () => Get.to(() => const ChangePasswordScreen())),
            _buildSettingOption(Icons.language, "Langue et région", () => Fluttertoast.showToast(msg: "Fonctionnalité à venir")),
            _buildSettingOption(Icons.help_outline, "Support et aide", () => Fluttertoast.showToast(msg: "Fonctionnalité à venir")),
            const SizedBox(height: 20),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String username, String profileType) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null ? FileImage(File(_imageFile!.path)) : const AssetImage("assets/images/user.webp") as ImageProvider,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(getProfileById(int.parse(profileType)), style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSettingOption(IconData icon, String title, void Function() onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => onTap(),
    );
  }

  Widget _buildLogoutButton() {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        onPressed: () => controller.logout(),
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text("Déconnexion", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

getProfileById(int id) {
  switch (id) {
    case 1:
      return "Admin";
    case 2:
      return "Manager";
    case 3:
      return "Commercial";
    case 4:
      return "Client";
    default:
      return "Inconnu";
  }
}
