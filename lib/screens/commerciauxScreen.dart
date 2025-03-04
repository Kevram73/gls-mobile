import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/usersController.dart';
import 'package:gls/models/user.dart';
import 'package:gls/screens/addUserScreen.dart';
import 'package:gls/screens/detailsCommercScreen.dart';

class CommercialListScreen extends StatefulWidget {
  const CommercialListScreen({super.key});

  @override
  _CommercialListScreenState createState() => _CommercialListScreenState();
}

class _CommercialListScreenState extends State<CommercialListScreen> {
  final UsersController controller = Get.put(UsersController());

  @override
  void initState() {
    super.initState();
    controller.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Managers, Commerciaux, Clients
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildTabView(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Liste des utilisateurs", style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Get.back(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.to(() => AddUserScreen());
          },
          child: const Text("Ajouter", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ),
        
      ],
      bottom: const TabBar(
        labelColor: Colors.black,
        indicatorColor: Colors.green,
        tabs: [
          Tab(text: "Managers"),
          Tab(text: "Commerciaux"),
          Tab(text: "Clients"),
        ],
      ),
    );
  }

  Widget _buildTabView() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return TabBarView(
        children: [
          _buildList(controller.filteredUsersByType(2)), // Managers
          _buildList(controller.filteredUsersByType(3)), // Commerciaux
          _buildList(controller.filteredUsersByType(4)), // Clients
        ],
      );
    });
  }

  Widget _buildList(List<User> users) {
    if (users.isEmpty) {
      return const Center(
        child: Text("Aucun résultat trouvé", style: TextStyle(fontSize: 16, color: Colors.grey)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 5),
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          leading: const CircleAvatar(backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
          title: Text("${user.nom} ${user.prenom}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          subtitle: Text(user.email ?? "Aucun email", style: const TextStyle(color: Colors.grey)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: () => Get.to(() => CommercialDetailScreen(user: user), arguments: user),
        );
      },
    );
  }
}
