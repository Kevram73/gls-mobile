import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/venteController.dart';
import 'package:gls/helpers/coloors.dart';
import 'package:gls/models/user.dart';
import 'package:gls/models/vente.dart';
import 'package:gls/models/journal.dart';

class NewVenteScreen extends StatefulWidget {
  const NewVenteScreen({super.key});

  @override
  _NewVenteScreenState createState() => _NewVenteScreenState();
}

class _NewVenteScreenState extends State<NewVenteScreen> {
  final VenteController controller = Get.put(VenteController());

  final TextEditingController quantityController = TextEditingController(text: "1");

  var selectedClient = User().obs;
  var selectedJournal = Journal().obs;
  RxDouble journalPrice = 0.0.obs;

  @override
  void initState() {
    super.initState();
    controller.fetchJournals();
    controller.fetchClients();
    
    if (controller.clients.isNotEmpty) {
      selectedClient.value = controller.clients.first;
      journalPrice.value = double.parse(controller.journals.first.price!);
    }
  }

  void _addVente() {
    int? quantity = int.tryParse(quantityController.text);
    if (selectedJournal.value.isNull || quantity == null || quantity <= 0 || selectedClient.value.isNull) {
      Get.snackbar("Erreur", "Veuillez remplir tous les champs correctement",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    Vente newVente = Vente(
      id: DateTime.now().millisecondsSinceEpoch,
      date: DateTime.now(),
      montant: (journalPrice.value * quantity).toString(),
      pointOfSaleId: 1,
      clientId: selectedClient.value.id,
      journalId: selectedJournal.value.id,
      nbre: quantity,
      sellerId: 1,
      isPaid: false,
    );

    controller.addVente(newVente);
    Get.back();
    quantityController.text = "1";
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: Coloors.primaryColor,
            title: const Text("Créer une vente", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Nom du client"),
                  _buildClientDropdown(),
                    
                  const SizedBox(height: 15),
                  _buildSectionTitle("Journal"),
                  _buildJournalDropdown(),
                    
                  const SizedBox(height: 15),
                  _buildSectionTitle("Prix unitaire"),
                  _buildReadOnlyField("${journalPrice.value} FCFA"),
                    
                  const SizedBox(height: 15),
                  _buildSectionTitle("Nombre vendu"),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                    
                  const SizedBox(height: 15),
                  _buildSectionTitle("Montant total"),
                  _buildReadOnlyField("${_calculateTotal()} FCFA"),
                    
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _addVente,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text("Nouvelle vente", style: TextStyle(fontSize: 16, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Coloors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildClientDropdown() {
    return Obx(() => DropdownButtonFormField<User>(
          value: controller.clients.isNotEmpty ? controller.clients.first : null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: controller.clients.map((client) {
            return DropdownMenuItem(
              value: client,
              child: Text("${client.nom} ${client.prenom}"),
            );
          }).toList(),
          onChanged: (value) => selectedClient.value = value!,
        ));
  }

  Widget _buildJournalDropdown() {
    return Obx(() => DropdownButtonFormField<Journal>(
          value: controller.journals.isNotEmpty ? controller.journals.first : null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: controller.journals.map((journal) {
            return DropdownMenuItem(
              value: journal,
              child: Text(journal.title!),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              selectedJournal.value = value;
              journalPrice.value = double.parse(value.price!);
            }
          },
        ));
  }

  Widget _buildReadOnlyField(String text) {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      readOnly: true,
      controller: TextEditingController(text: text),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  double _calculateTotal() {
    int quantity = int.tryParse(quantityController.text) ?? 1;
    return journalPrice.value * quantity;
  }
}
