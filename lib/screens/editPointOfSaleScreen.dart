import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/posController.dart';
import 'package:gls/models/point_of_sale.dart';
import 'package:gls/models/user.dart';

class EditPointOfSaleScreen extends StatelessWidget {
  final PointOfSaleController controller = Get.find<PointOfSaleController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  var selectedManager = User().obs;
  RxInt selectedManagerId = 0.obs;
  final RxBool isActive = false.obs;
  final int pointOfSaleId;

  EditPointOfSaleScreen({super.key, required PointOfSale pointOfSale})
      : pointOfSaleId = pointOfSale.id ?? 0 {
    nameController.text = pointOfSale.name ?? "";
    addressController.text = pointOfSale.address ?? "";
    cityController.text = pointOfSale.city ?? "";
    isActive.value = pointOfSale.isActive ?? false;
    selectedManagerId.value = pointOfSale.ownerId ?? 0;
  }

  void _updatePointOfSale() {
    final String name = nameController.text.trim();
    final String address = addressController.text.trim();
    final String city = cityController.text.trim();

    if (name.isEmpty || city.isEmpty) {
      Fluttertoast.showToast(msg: "Le nom, la ville et le manager sont obligatoires", backgroundColor: Colors.red);
      return;
    }

    final updatedPointOfSale = PointOfSale(
      id: pointOfSaleId,
      name: name,
      address: address.isNotEmpty ? address : null,
      city: city,
      isActive: isActive.value,
      ownerId: selectedManager.value.id,
    );

    controller.editPointOfSale(updatedPointOfSale.id!, updatedPointOfSale);
    Get.back();
    controller.fetchPointsOfSale();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text("Modifier le Point de Vente")),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Modifier le Point de Vente")),
            body: Center(child: Text("Erreur: ${snapshot.error}")),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Modifier le Point de Vente", style: TextStyle(fontWeight: FontWeight.bold)),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(nameController, "Nom du point de vente"),
                  const SizedBox(height: 10),
                  _buildTextField(addressController, "Adresse (optionnelle)"),
                  const SizedBox(height: 10),
                  _buildTextField(cityController, "Ville"),
                  const SizedBox(height: 10),
                  _buildManagerDropdown(),
                  const SizedBox(height: 15),
                  _buildStatusSwitch(),
                  const SizedBox(height: 20),
                  _buildSaveButton(),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  /// ✅ **Champs de texte stylisés**
  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  /// ✅ **Dropdown pour sélectionner un manager**
  Widget _buildManagerDropdown() {
    return Obx(() {
      return DropdownButtonFormField<User>(
        decoration: InputDecoration(
          labelText: "Sélectionnez un manager",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        items: controller.users.map((user) {
          return DropdownMenuItem<User>(
            value: user,
            child: Text("${user.nom} ${user.prenom}"),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            selectedManager.value = value;
          }
        },
      );
    });
  }

  /// ✅ **Switch pour activer/désactiver**
  Widget _buildStatusSwitch() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Statut Actif", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Switch(
            value: isActive.value,
            activeColor: Colors.green,
            inactiveTrackColor: Colors.grey[300],
            inactiveThumbColor: Colors.grey,
            onChanged: (value) => isActive.value = value,
          ),
        ],
      );
    });
  }

  /// ✅ **Bouton de mise à jour**
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _updatePointOfSale,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("Mettre à jour", style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
