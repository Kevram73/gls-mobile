import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPointOfSaleScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final RxBool isActive = true.obs;

  RegisterPointOfSaleScreen({super.key});

  void _savePointOfSale() {
    final String name = nameController.text.trim();
    final String address = addressController.text.trim();
    final String city = cityController.text.trim();
    
    if (name.isEmpty || city.isEmpty) {
      Get.snackbar("Erreur", "Le nom et la ville sont obligatoires", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    
    Get.snackbar("Succès", "Point de vente enregistré avec succès", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enregistrer un Point de Vente", style: TextStyle(fontWeight: FontWeight.bold)),
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
        onPressed: _savePointOfSale,
        child: const Text("Enregistrer"),
      ),
    );
  }
}
