import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/posController.dart';
import 'package:gls/helpers/coloors.dart';
import 'package:gls/screens/editPointOfSaleScreen.dart';

class PointOfSaleListScreen extends StatelessWidget {
  final PointOfSaleController controller = Get.put(PointOfSaleController());

  const PointOfSaleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Points de Vente", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Coloors.primaryColor,
        onPressed: () => controller.fetchPointsOfSale(),
        child: const Icon(Icons.refresh),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 15),
            Expanded(child: _buildPointOfSaleList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) => controller.searchQuery.value = value.toLowerCase(),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: "Rechercher un point de vente ou un propriétaire...",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildPointOfSaleList() {
    return Obx(() {
      final filteredPoints = controller.filteredPoints;

      if (filteredPoints.isEmpty) {
        return const Center(
          child: Text("Aucun point de vente trouvé", style: TextStyle(fontSize: 16, color: Colors.grey)),
        );
      }

      return ListView.builder(
        itemCount: filteredPoints.length,
        itemBuilder: (context, index) {
          final pos = filteredPoints[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(pos.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  _buildStatusIndicator(pos.isActive == 1),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${pos.address ?? "Adresse inconnue"}, ${pos.city}"),
                  Text("Propriétaire : ${pos.owner ?? "Inconnu"}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Get.to(() => EditPointOfSaleScreen(pointOfSale: pos));
                    }
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.deletePointOfSale(pos.id),
                  ),
                ],
              ),
              onTap: () {
                Get.to(() => EditPointOfSaleScreen(pointOfSale: pos));
              },
            ),
          );
        },
      );
    });
  }

  Widget _buildStatusIndicator(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isActive ? "Actif" : "Inactif",
        style: TextStyle(
          color: isActive ? Colors.green[900] : Colors.red[900],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
