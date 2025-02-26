import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/messageController.dart';
import 'package:gls/controllers/usersController.dart';
import 'package:gls/screens/messageBoxScreen.dart';
import 'package:gls/screens/selectUserScreen.dart';
import 'package:gls/models/user.dart';

class MessagerieScreen extends StatefulWidget {
  const MessagerieScreen({super.key});

  @override
  _MessagerieScreenState createState() => _MessagerieScreenState();
}

class _MessagerieScreenState extends State<MessagerieScreen> {
  final UsersController userController = Get.put(UsersController());
  final MessageController messageController = Get.put(MessageController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData(); // Chargement initial des utilisateurs et contacts
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchData(); // 🔄 Recharge la liste à chaque retour sur l'écran
  }

  void _fetchData() {
    userController.fetchUsers();
    messageController.usersAlreadyContacted();
  }

  @override
  void dispose() {
    searchController.dispose(); // Libération de mémoire
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Messagerie",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment),
            onPressed: () {
              Get.to(
                () => const SelectUserScreen(),
                transition: Transition.rightToLeft,
              )?.then((_) {
                _fetchData(); // Actualiser après retour
              });
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
                onChanged: messageController.searchQuery.call,
                decoration: InputDecoration(
                  hintText: "Rechercher un utilisateur...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (userController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (messageController.contactedUsers.isEmpty) {
                  return const Center(
                    child: Text(
                      "Aucun utilisateur trouvé",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: messageController.contactedUsers.length,
                  itemBuilder: (context, index) {
                    final User user = messageController.contactedUsers[index];

                    return InkWell(
                      onTap: () {
                        Get.to(
                          () => MessageBoxScreen(user: user),
                          transition: Transition.fadeIn,
                        )?.then((_) {
                          _fetchData(); // 🔄 Mettre à jour après retour du chat
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
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
                                const CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage("assets/images/user.webp"),
                                ),
                                if (user.actif == true)
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
                            Expanded(
                              child: Text(
                                "${user.nom} ${user.prenom}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
