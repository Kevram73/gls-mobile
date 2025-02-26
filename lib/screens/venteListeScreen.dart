import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/venteController.dart';
import 'package:gls/helpers/coloors.dart';
import 'package:gls/models/vente.dart';
import 'package:gls/screens/detailsVenteScreen.dart';

class VenteListScreen extends StatelessWidget {
  final VenteController controller = Get.put(VenteController());

  VenteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Coloors.primaryColor,
        title: const Text("Liste des ventes", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 15),
            Expanded(child: _buildVenteList()),
          ],
        ),
      ),
    );
  }

  /// 🔍 **Barre de Recherche**
  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) => controller.searchQuery.value = value.toLowerCase(),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: "Rechercher une vente...",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// 📋 **Liste des ventes dynamiques**
  Widget _buildVenteList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final ventes = controller.filteredVentes;

      if (ventes.isEmpty) {
        return const Center(child: Text("Aucune vente trouvée", style: TextStyle(fontSize: 16, color: Colors.grey)));
      }

      return ListView.builder(
        itemCount: ventes.length,
        itemBuilder: (context, index) {
          final vente = ventes[index];
          return Dismissible(
            key: Key(vente.id.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => controller.deleteVente(vente.id!),
            child: _buildVenteCard(vente),
          );
        },
      );
    });
  }

  /// 📰 **Carte Individuelle de Vente**
  Widget _buildVenteCard(Vente vente) {
    return InkWell(
      onTap: () {
        Get.to(() => DetailsVenteScreen(vente: vente));
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          title: Text(vente.nbre! > 1 ? "${vente.nbre} journaux vendus" : "1 journal vendu",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text("${vente.montant} FCFA", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Coloors.primaryColor)),
              Text(vente.date.toString(), style: const TextStyle(fontSize: 14, color: Colors.black54)),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: vente.isPaid! ? Colors.green[100] : Colors.orange[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              vente.isPaid! ? "Payé" : "Non payé",
              style: TextStyle(
                color: vente.isPaid! ? Colors.green[900] : Colors.orange[900],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
