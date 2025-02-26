import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/helpers/coloors.dart';
import 'package:gls/models/vente.dart';
import 'package:intl/intl.dart';

class DetailsVenteScreen extends StatelessWidget {
  final Vente vente;

  const DetailsVenteScreen({super.key, required this.vente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Coloors.primaryColor,
        title: const Text(
          "Détails de la vente",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              "Nom du client",
              vente.client != null
                  ? "${vente.client!.nom} ${vente.client!.prenom}"
                  : "Inconnu",
            ),
            _buildDetailRow(
              "Statut",
              vente.isPaid == true ? "Payé" : "Non payé",
              valueColor: vente.isPaid == true ? Colors.green : Colors.orange,
            ),
            _buildDetailRow("Prix", "${vente.montant} FCFA"),
            _buildDetailRow(
              "Date",
              vente.date != null
                  ? DateFormat('dd/MM/yyyy HH:mm').format(vente.date!)
                  : "N/A",
            ),
            _buildDetailRow(
              "Titre du journal",
              vente.journalId != null ? "Journal #${vente.journalId}" : "N/A",
            ),
            _buildDetailRow("Quantité vendue", "${vente.nbre}"),
            const Divider(),
            _buildDetailRow(
              "Point de vente",
              vente.pointOfSale != null
                  ? vente.pointOfSale!.name ?? "Inconnu"
                  : "Inconnu",
            ),
            if (vente.pointOfSale != null)
              _buildDetailRow(
                "Adresse du point de vente",
                "${vente.pointOfSale!.address ?? 'N/A'}, ${vente.pointOfSale!.city ?? ''}",
              ),
            _buildDetailRow(
              "Vendeur",
              vente.seller != null
                  ? "${vente.seller!.nom} ${vente.seller!.prenom}"
                  : "Inconnu",
            ),
            const SizedBox(height: 30),
            // Écran en mode consultation : aucun bouton d'édition ou d'enregistrement.
          ],
        ),
      ),
    );
  }

  /// Affichage d’une ligne de détail avec mise en valeur
  Widget _buildDetailRow(String label, String value, {Color valueColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: valueColor),
            ),
          ),
        ],
      ),
    );
  }
}
