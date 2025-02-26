import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/posController.dart';
import 'package:gls/helpers/coloors.dart';
import 'package:gls/screens/editPointOfSaleScreen.dart';
import 'package:gls/screens/newPointOfSaleScreen.dart';

class PointOfSaleListScreen extends StatelessWidget {
  final PointOfSaleController controller = Get.put(PointOfSaleController());

  PointOfSaleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchPointsOfSale();
            },
            child: Padding(
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
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Coloors.primaryColor,
      title: const Text("Points de Vente", style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Coloors.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onPressed: () => Get.to(() => RegisterPointOfSaleScreen()),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) => controller.searchQuery.value = value.toLowerCase(),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        hintText: "Rechercher un point de vente...",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[200],
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

          return Dismissible(
            key: Key(pos.id.toString()),
            direction: DismissDirection.endToStart,
            background: _buildDeleteBackground(),
            confirmDismiss: (direction) async {
              return await _confirmDeletePointOfSale(context, pos);
            },
            child: _buildPointOfSaleCard(pos),
          );
        },
      );
    });
  }

  Widget _buildPointOfSaleCard(dynamic pos) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.storefront, color: Coloors.primaryColor, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pos.name!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text("${pos.address ?? "Adresse inconnue"}, ${pos.city}"),
                  Text("Propriétaire : ${pos.owner ?? "Inconnu"}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Coloors.primaryColor)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildStatusChip(pos.isActive == 1), // ✅ Statut bien aligné à droite
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Get.to(() => EditPointOfSaleScreen(pointOfSale: pos));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Future<bool> _confirmDeletePointOfSale(BuildContext context, pointOfSale) async {
    bool isConfirmed = false;
    await Get.defaultDialog(
      title: "Supprimer",
      middleText: "Voulez-vous supprimer \"${pointOfSale.name}\" ?",
      textCancel: "Annuler",
      textConfirm: "Supprimer",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.black,
      onCancel: () {
        isConfirmed = false;
      },
      onConfirm: () {
        controller.deletePointOfSale(pointOfSale.id);
        Get.back();
        isConfirmed = true;

        Get.snackbar(
          "Succès",
          "Le point de vente \"${pointOfSale.name}\" a été supprimé.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
    return isConfirmed;
  }

  Widget _buildStatusChip(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: isActive ? Colors.green[700] : Colors.red[700],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isActive ? "Actif" : "Inactif",
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
