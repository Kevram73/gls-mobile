import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/posController.dart';
import 'package:gls/helpers/coloors.dart';
import 'package:gls/models/point_of_sale.dart';
import 'package:gls/models/user.dart';

class RegisterPointOfSaleScreen extends StatelessWidget {
  var controller = Get.find<PointOfSaleController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final RxBool isActive = true.obs;
  var selectedOwner = User().obs;

  RegisterPointOfSaleScreen({super.key});

  void _savePointOfSale() {
    final String name = nameController.text.trim();
    final String address = addressController.text.trim();
    final String city = cityController.text.trim();
    final int ownerId = selectedOwner.value.id!;
    final bool isActiveValue = isActive.value;

    if (name.isEmpty || city.isEmpty) {
          Fluttertoast.showToast(msg: "Le nom, la ville et le propriétaire sont obligatoires", backgroundColor: Colors.red);
      return;
    }

    controller.addPointOfSale(PointOfSale(
      name: name,
      address: address,
      city: city,
      ownerId: selectedOwner.value.id,
      isActive: isActiveValue,
    ));

    Fluttertoast.showToast(msg: "Point de vente enregistré avec succès", backgroundColor: Colors.green, textColor: Colors.white);
    Get.back();
    controller.fetchPointsOfSale();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Coloors.primaryColor,
        title: const Text("Nouveau Point de Vente", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Informations du Point de Vente",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildTextField(nameController, "Nom du point de vente"),
              const SizedBox(height: 15),
              _buildTextField(addressController, "Adresse (optionnelle)"),
              const SizedBox(height: 15),
              _buildTextField(cityController, "Ville"),
              const SizedBox(height: 15),
              if(controller.users.isNotEmpty) _buildOwnerDropdown(),
              const SizedBox(height: 15),
              _buildStatusSwitch(),
              const SizedBox(height: 25),
              _buildSaveButton(),
            ],
          ),
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

  Widget _buildOwnerDropdown() {
    return Obx(() => DropdownButtonFormField<User>(
          value: controller.users.first,
          decoration: InputDecoration(
            labelText: "Sélectionnez un propriétaire",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: controller.users.map((owner) {
            return DropdownMenuItem<User>(
              value: owner,
              child: Text("${owner.nom} ${owner.prenom}"),
              onTap: () {
                selectedOwner.value = owner;
              },
            );
          }).toList(),
          onChanged: (value) {},
        ));
  }

  Widget _buildStatusSwitch() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Statut Actif", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Switch(
              value: isActive.value,
              onChanged: (value) => isActive.value = value,
            ),
          ],
        ));
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Coloors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: _savePointOfSale,
        child: const Text(
          "Enregistrer",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
