import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/usersController.dart';
import 'package:gls/models/user.dart';
import 'package:gls/screens/messageBoxScreen.dart';

class SelectUserScreen extends StatefulWidget {
  const SelectUserScreen({super.key});

  @override
  _SelectUserScreenState createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  final UsersController userController = Get.put(UsersController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userController.fetchUsers();
  }

  @override
  void dispose() {
    searchController.dispose(); // Libère le contrôleur pour éviter les fuites de mémoire.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Choisir un utilisateur",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 15),
            Expanded(
              child: Obx(() => _buildUserList(userController.filteredUsers)),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔍 Barre de recherche
  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,
      onChanged: userController.searchQuery,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: "Rechercher un utilisateur...",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// 📋 Liste des utilisateurs
  Widget _buildUserList(List<User> filteredUsers) {
    if (filteredUsers.isEmpty) {
      return const Center(
        child: Text(
          "Aucun utilisateur trouvé",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return ListTile(
          onTap: () {
          Get.to(
            () => MessageBoxScreen(user: user),
            transition: Transition.fadeIn,
          );
        },
          leading: const CircleAvatar(
            backgroundImage: AssetImage("assets/images/user.webp"),
          ),
          title: Text(
            "${user.nom} ${user.prenom}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        
        );
      },
    );
  }
}
