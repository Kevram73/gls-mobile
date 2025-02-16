import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/posController.dart';
import 'package:gls/models/point_of_sale.dart';

class EditPointOfSaleScreen extends StatelessWidget {
  final PointOfSaleController controller = Get.find<PointOfSaleController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final RxString selectedManager = ''.obs;
  final RxInt isActive = 1.obs;

  EditPointOfSaleScreen({super.key, required PointOfSale pointOfSale}) {
    nameController.text = pointOfSale.name;
    addressController.text = pointOfSale.address!;
    cityController.text = pointOfSale.city;
    selectedManager.value = pointOfSale.owner;
    isActive.value = pointOfSale.isActive;
  }

  void _updatePointOfSale() {
    final String name = nameController.text.trim();
    final String address = addressController.text.trim();
    final String city = cityController.text.trim();
    final String managerName = selectedManager.value;

    if (name.isEmpty || city.isEmpty || managerName.isEmpty) {
      Get.snackbar("Erreur", "Le nom, la ville et le manager sont obligatoires",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    final updatedPointOfSale = {
      'id': controller.pointsOfSale.firstWhereOrNull((p) => p.name == name)?.id ?? 0,
      'name': name,
      'address': address,
      'city': city,
      'isActive': isActive.value,
      'owner': managerName,
    };
    var updateData = PointOfSale.fromJson(updatedPointOfSale);


    controller.editPointOfSale(updateData.id, updateData);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
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

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildManagerDropdown() {
    return Obx(() => DropdownButtonFormField<String>(
          value: selectedManager.value.isNotEmpty ? selectedManager.value : null,
          decoration: InputDecoration(
            labelText: "Sélectionnez un manager",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: controller.users.map((pos) {
            return DropdownMenuItem<String>(
              value: pos.id.toString(),
              child: Text("${pos.nom} ${pos.prenom}"),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              selectedManager.value = value;
            }
          },
        ));
  }

  Widget _buildStatusSwitch() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Statut Actif", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Switch(
              value: isActive.value == 1,
              onChanged: (value) => isActive.value = value ? 1 : 0,
            ),
          ],
        ));
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _updatePointOfSale,
        child: const Text("Mettre à jour"),
      ),
    );
  }
}
