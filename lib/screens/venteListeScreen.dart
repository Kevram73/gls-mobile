import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/screens/detailsVenteScreen.dart';

class VenteListScreen extends StatefulWidget {
  const VenteListScreen({super.key});

  @override
  _VenteListScreenState createState() => _VenteListScreenState();
}

class _VenteListScreenState extends State<VenteListScreen> {
  final List<Map<String, dynamic>> ventes = [
    {"title": "Vente journal", "price": 2000, "date": "12/12/2022", "quantity": 1, "status": "Non soumis"},
    {"title": "Vente journal", "price": 8000, "date": "12/12/2022", "quantity": 4, "status": "Soumis"},
    {"title": "Business Report", "price": 6000, "date": "12/12/2022", "quantity": 3, "status": "Soumis"},
    {"title": "Business Report", "price": 2000, "date": "12/12/2022", "quantity": 1, "status": "Non soumis"},
  ];

  String selectedDate = "4";
  String searchQuery = "";
  final List<Map<String, String>> dates = [
    {"day": "Lun", "date": "4"},
    {"day": "Mar", "date": "5"},
    {"day": "Mer", "date": "6"},
    {"day": "Jeu", "date": "7"},
    {"day": "Ven", "date": "8"},
  ];

  void _deleteVente(int index) {
    setState(() => ventes.removeAt(index));
    Get.snackbar("Supprimé", "Vente supprimée avec succès", snackPosition: SnackPosition.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste de toutes les ventes", style: TextStyle(fontWeight: FontWeight.bold)),
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
            _buildDateSelector(),
            const SizedBox(height: 15),
            _buildSearchBar(),
            const SizedBox(height: 15),
            Expanded(child: _buildVenteList()),
          ],
        ),
      ),
    );
  }

  /// 🔥 **Widget : Sélecteur de Date (Mini Calendrier)**
 Widget _buildDateSelector() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Choisir date",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: dates.map((date) {
          final String? day = date["day"];
          final String? dateValue = date["date"];
          final bool isSelected = selectedDate == dateValue;

          return GestureDetector(
            onTap: () {
              if (dateValue != null) {
                setState(() => selectedDate = dateValue);
              }
            },
            child: Container(
              width: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    day ?? "",
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateValue ?? "",
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ],
  );
}

  /// 🔍 **Barre de Recherche**
  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) => setState(() => searchQuery = value),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: "Rechercher une vente...",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// 📋 **Liste des ventes filtrées**
  Widget _buildVenteList() {
    final filteredVentes = ventes.where((vente) {
      return vente["title"].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    if (filteredVentes.isEmpty) {
      return const Center(child: Text("Aucune vente trouvée", style: TextStyle(fontSize: 16, color: Colors.grey)));
    }

    return ListView.builder(
      itemCount: filteredVentes.length,
      itemBuilder: (context, index) {
        final vente = filteredVentes[index];
        return Dismissible(
          key: Key(vente["title"] + index.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => _deleteVente(index),
          child: _buildVenteCard(vente),
        );
      },
    );
  }

  /// 📰 **Carte Individuelle de Vente**
  Widget _buildVenteCard(Map<String, dynamic> vente) {
    return InkWell(
      onTap: (){
        Get.to(() => DetailsVenteScreen());
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          title: Text(vente["title"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text("${vente["price"]} FCFA", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
              Text("${vente["date"]} | ${vente["quantity"]} journal", style: const TextStyle(fontSize: 14, color: Colors.black54)),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: vente["status"] == "Non soumis" ? Colors.orange[100] : Colors.green[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              vente["status"],
              style: TextStyle(
                color: vente["status"] == "Non soumis" ? Colors.orange[900] : Colors.green[900],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
