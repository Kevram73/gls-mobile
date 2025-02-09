import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsVenteScreen extends StatelessWidget {
  const DetailsVenteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 Fake Data pour afficher des informations fictives
    final Map<String, dynamic> vente = {
      "client": "Ghis",
      "status": "Non soumis",
      "price": 2000,
      "date": "12/12/2022",
      "journal": "La politique",
      "quantity": 2,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail", style: TextStyle(fontWeight: FontWeight.bold)),
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
            _buildDetailRow("Nom du client", vente["client"]),
            _buildDetailRow(
              "Statut",
              vente["status"],
              valueColor: vente["status"] == "Non soumis" ? Colors.orange : Colors.green,
            ),
            _buildDetailRow("Prix", "${vente["price"]} FCFA"),
            _buildDetailRow("Date", vente["date"]),
            _buildDetailRow("Titre du journal", vente["journal"]),
            _buildDetailRow("Nombre vendus", vente["quantity"].toString()),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOutlinedButton("Modifier", () {}),
                _buildOutlinedButton("Enregistrer", () {}),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {},
                child: const Text(
                  "Soumettre la vente",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color valueColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontSize: 16, color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildOutlinedButton(String text, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.green,
        side: const BorderSide(color: Colors.green),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}
