import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/journalController.dart';
import 'package:gls/helpers/coloors.dart';

class AddJournalScreen extends StatefulWidget {
  const AddJournalScreen({super.key});

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final _formKey = GlobalKey<FormState>(); // Clé pour le formulaire
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final JournalController controller = Get.find<JournalController>();

  void _saveJournal() {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text;
      double price = double.parse(_priceController.text);
      controller.addJournal(title, price).then((value) {
        Get.back();
        controller.fetchJournals();
      });
      _titleController.clear();
      _priceController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un Journal"),
        backgroundColor: Coloors.primaryColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } 
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Champ Title
                  _buildTextField(_titleController, "Titre du journal"),
                  const SizedBox(height: 16),
                  _buildTextField(_priceController, "Prix du journal"),
                  const SizedBox(height: 24),
          
                  // Bouton Ajouter
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveJournal,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Coloors.primaryColor,
                      ),
                      child: Text("Ajouter", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
