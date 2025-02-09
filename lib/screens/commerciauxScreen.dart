import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gls/helpers/coloors.dart';
import 'package:gls/screens/detailsCommercScreen.dart';

class CommercialListScreen extends StatelessWidget {
  CommercialListScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  final List<String> commerciaux = [
    "Karen Den",
    "Anoop Jain",
    "Ashley Hills",
    "Karen Den",
    "Anoop Jain",
    "David Silverstein",
    "Brooke Davis",
    "Karen Den"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildSearchBar(),
            Expanded(child: _buildCommercialList()),
          ],
        ),
      ),
    );
  }

  // 🔹 Barre d'AppBar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Liste des commerciaux", style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Get.back(),
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text("Ajouter", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  // 🔹 Barre de recherche
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "rechercher",
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  // 🔹 Liste des commerciaux
  Widget _buildCommercialList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemCount: commerciaux.length,
      separatorBuilder: (_, __) => const SizedBox(height: 5),
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          leading: const CircleAvatar(backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
          title: Text(commerciaux[index], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: () {
            Get.to(() => CommercialDetailScreen());
          },
        );
      },
    );
  }
}
