import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/journalController.dart';
import 'package:gls/helpers/coloors.dart';
import 'package:gls/models/journal.dart';
import 'package:gls/screens/addJournalScreen.dart';
import 'package:gls/screens/editJournalScreen.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final JournalController controller = Get.put(JournalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => controller.isSearching.value
            ? TextField(
                autofocus: true,
                onChanged: (value) => controller.searchQuery.value = value.toLowerCase(),
                decoration: const InputDecoration(
                  hintText: "Rechercher un journal...",
                  border: InputBorder.none,
                ),
              )
            : const Text("Liste des Journaux")),
        backgroundColor: Coloors.primaryColor,
        elevation: 4,
        actions: [
          Obx(() => IconButton(
                icon: Icon(controller.isSearching.value ? Icons.close : Icons.search),
                onPressed: () {
                  controller.toggleSearch();
                },
              )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.filteredJournals.isEmpty) {
          return const Center(child: Text("Aucun journal disponible", style: TextStyle(fontSize: 18)));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: controller.filteredJournals.length,
            itemBuilder: (context, index) {
              final journal = controller.filteredJournals[index];
              return _buildJournalCard(journal);
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddJournalScreen());
        },
        backgroundColor: Coloors.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // 📌 Widget amélioré pour afficher chaque journal sous forme de Card bien designée
  Widget _buildJournalCard(Journal journal) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: InkWell(
        onTap: () {
          Get.to(() => EditJournalScreen(journal: journal));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 📰 Icône du journal
              const Icon(Icons.newspaper, color: Coloors.primaryColor, size: 30),
              const SizedBox(width: 12),

              // 📜 Détails du journal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 📌 Titre en gras
                    Text(
                      journal.title!,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),

                    // 💰 Prix en plus grand et couleur
                    Text(
                      "${journal.price} FCFA",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              // 🟢 Badge du statut (Actif ou Inactif)
              _buildStatusBadge(journal.isActive == 1 ? "Actif" : "Inactif"),

              const SizedBox(width: 10),

              // 🗑 Icône de suppression
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _confirmDeleteJournal(context, journal);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 📌 Boîte de dialogue de confirmation avant suppression
  void _confirmDeleteJournal(BuildContext context, Journal journal) {
  Get.defaultDialog(
    title: "Supprimer",
    middleText: "Voulez-vous vraiment supprimer \"${journal.title}\" ?",
    titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    middleTextStyle: const TextStyle(fontSize: 16),
    backgroundColor: Colors.white,
    barrierDismissible: false, // Empêche la fermeture en cliquant en dehors
    radius: 10,
    textCancel: "Annuler",
    textConfirm: "Supprimer",
    confirmTextColor: Colors.white,
    buttonColor: Colors.red,
    cancelTextColor: Colors.black,
    onCancel: () {
      Get.back(); // Ferme la boîte de dialogue si annulé
    },
    onConfirm: () async {
      await controller.deleteJournal(journal.id!); 
      Get.back();
      controller.fetchJournals();

      // Affichage du SnackBar avec Get.snackbar pour éviter le contexte
      Get.snackbar(
        "Succès",
        "Le journal \"${journal.title}\" a été supprimé.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    },
  );
}


  // 📌 Badge stylisé pour afficher "Actif" ou "Inactif"
  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: status == "Actif" ? Colors.green[600] : Colors.red[600],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
