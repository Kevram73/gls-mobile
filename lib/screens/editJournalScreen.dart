import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/helpers/coloors.dart';
import 'package:gls/models/journal.dart';
import 'package:gls/controllers/journalController.dart';

class EditJournalScreen extends StatefulWidget {
  final Journal journal;
  const EditJournalScreen({super.key, required this.journal});

  @override
  State<EditJournalScreen> createState() => _EditJournalScreenState();
}

class _EditJournalScreenState extends State<EditJournalScreen> {
  final JournalController controller = Get.find<JournalController>(); // Récupération du controller

  late TextEditingController _titleController;
  late TextEditingController _priceController;
  String _selectedStatus = "Actif"; // Valeur par défaut pour le statut

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.journal.title);
    _priceController = TextEditingController(text: widget.journal.price.toString());
    _selectedStatus = widget.journal.isActive == 1 ? "Actif" : "Inactif"; // Récupérer le statut existant
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_titleController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    double? price = double.tryParse(_priceController.text);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Le prix doit être un nombre valide")),
      );
      return;
    }

    // Mettre à jour le journal dans le controller
    controller.editJournal(
      widget.journal.id!,
      _titleController.text,
      price,
      _selectedStatus == "Actif" ? 1 : 0,
    ).then((value) {
      Get.back(); // Retour à la liste après modification
    controller.fetchJournals();
    });


    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier le journal"),
        backgroundColor: Coloors.primaryColor,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Titre", controller: _titleController),
            const SizedBox(height: 15),
            _buildTextField("Prix", controller: _priceController, keyboardType: TextInputType.number),
            const SizedBox(height: 15),

            // Sélection du statut (Actif/Inactif)
            _buildDropdownStatus(),

            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Coloors.primaryColor),
                onPressed: _saveChanges,
                child: const Text("Modifier", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour les champs de texte
  Widget _buildTextField(String hint, {TextEditingController? controller, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Widget pour le menu déroulant de sélection du statut
  Widget _buildDropdownStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStatus,
          isExpanded: true,
          items: ["Actif", "Inactif"].map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(status),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedStatus = value!;
            });
          },
        ),
      ),
    );
  }
}
