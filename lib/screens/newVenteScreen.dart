import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewVenteScreen extends StatefulWidget {
  const NewVenteScreen({super.key});

  @override
  _NewVenteScreenState createState() => _NewVenteScreenState();
}

class _NewVenteScreenState extends State<NewVenteScreen> {
  final TextEditingController journalController = TextEditingController();
  final TextEditingController quantityController = TextEditingController(text: "1");

  String selectedClient = "Ghis";
  final List<String> clients = ["Ghis", "Alice", "Marc", "John"];
  int journalPrice = 2000; // Prix fixe

  void _addVente() {
    if (journalController.text.isEmpty || int.tryParse(quantityController.text) == null) {
      Get.snackbar("Erreur", "Veuillez remplir tous les champs correctement");
      return;
    }

    Get.snackbar("Succès", "Vente ajoutée avec succès !");
    journalController.clear();
    quantityController.text = "1";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer une vente", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Nom du client"),
            DropdownButtonFormField<String>(
              value: selectedClient,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: clients.map((client) {
                return DropdownMenuItem(value: client, child: Text(client));
              }).toList(),
              onChanged: (value) => setState(() => selectedClient = value!),
            ),

            const SizedBox(height: 15),

            _buildSectionTitle("Prix"),
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
                prefixText: "FCFA ",
              ),
              readOnly: true,
              controller: TextEditingController(text: "$journalPrice"),
            ),

            const SizedBox(height: 15),

            _buildSectionTitle("Titre du journal"),
            TextField(
              controller: journalController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Entrer le nom du journal",
              ),
            ),

            const SizedBox(height: 15),

            _buildSectionTitle("Nombre vendu"),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: ElevatedButton.icon(
                onPressed: _addVente,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Nouvelle vente", style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
