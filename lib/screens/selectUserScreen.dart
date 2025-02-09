import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectUserScreen extends StatefulWidget {
  const SelectUserScreen({super.key});

  @override
  _SelectUserScreenState createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  // Liste d'utilisateurs (Fake data)
  final List<Map<String, String>> users = [
    {"name": "Karen Den", "avatar": "assets/images/user.webp"},
    {"name": "Anoop Jain", "avatar": "assets/images/user.webp"},
    {"name": "Ashley Hills", "avatar": "assets/images/user.webp"},
    {"name": "David Silverstein", "avatar": "assets/images/user.webp"},
    {"name": "Brooke Davis", "avatar": "assets/images/user.webp"},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users.where((user) {
      return user["name"]!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choisir un utilisateur", style: TextStyle(fontWeight: FontWeight.bold)),
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
            Expanded(child: _buildUserList(filteredUsers)),
          ],
        ),
      ),
    );
  }

  /// 🔍 **Barre de recherche**
  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,
      onChanged: (value) => setState(() => searchQuery = value),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: "Rechercher un utilisateur...",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// 📋 **Liste des utilisateurs**
  Widget _buildUserList(List<Map<String, String>> filteredUsers) {
    if (filteredUsers.isEmpty) {
      return const Center(child: Text("Aucun utilisateur trouvé", style: TextStyle(fontSize: 16, color: Colors.grey)));
    }

    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(user["avatar"]!),
          ),
          title: Text(user["name"]!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          onTap: () {
            Get.toNamed('/messageBox', arguments: user["name"]); // Passe le nom de l'utilisateur
          },
        );
      },
    );
  }
}
