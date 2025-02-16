import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/screens/messageBoxScreen.dart';
import 'package:gls/screens/selectUserScreen.dart';

class MessagerieScreen extends StatefulWidget {
  const MessagerieScreen({super.key});

  @override
  _MessagerieScreenState createState() => _MessagerieScreenState();
}

class _MessagerieScreenState extends State<MessagerieScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, String>> users = [
    {"name": "Karen Den", "avatar": "assets/images/user.webp", "status": "online"},
    {"name": "Anoop Jain", "avatar": "assets/images/user.webp", "status": "offline"},
    {"name": "Ashley Hills", "avatar": "assets/images/user.webp", "status": "online"},
    {"name": "David Silverstein", "avatar": "assets/images/user.webp", "status": "offline"},
    {"name": "Brooke Davis", "avatar": "assets/images/user.webp", "status": "online"},
  ];
  List<Map<String, String>> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    filteredUsers = users;
  }

  void filterUsers(String query) {
    setState(() {
      filteredUsers = users
          .where((user) => user["name"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,  
        title: const Text("Messagerie", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment),
            onPressed: () {
              Get.to(const SelectUserScreen());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: searchController,
                onChanged: filterUsers,
                decoration: InputDecoration(
                  hintText: "Rechercher un utilisateur...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(const MessageBoxScreen());
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage(user["avatar"]!),
                              ),
                              if (user["status"] == "online")
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Text(
                            user["name"]!,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
