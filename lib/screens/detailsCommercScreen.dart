import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/helpers/coloors.dart';

class CommercialDetailScreen extends StatelessWidget {
  final String commercialName = "Karen Den";
  final int totalVentes = 15;
  final String totalCA = "30000FCFA";

  final List<Map<String, String>> ventes = [
    {"date": "Aujourd’hui", "heure": "09 h", "ventes": "3 ventes", "ca": "2500FCFA"},
    {"date": "Sep 22, 2024", "heure": "09 h", "ventes": "2 ventes", "ca": "1500FCFA"},
    {"date": "Sep 23, 2024", "heure": "09 h", "ventes": "4 ventes", "ca": "3000FCFA"},
    {"date": "Sep 24, 2024", "heure": "09:30 AM", "ventes": "", "ca": "4000FCFA"},
  ];

  CommercialDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 15),
            _buildSalesList(),
          ],
        ),
      ),
    );
  }

  // 🔹 AppBar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Détails", style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Get.back(),
      ),
    );
  }

  // 🔹 Header (Info commercial + stats)
  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white, size: 30),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(commercialName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text("Ventes réalisées: $totalVentes", style: const TextStyle(fontSize: 14, color: Colors.black54)),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Coloors.primaryColor),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          ),
          child: const Text("Détails", style: TextStyle(color: Coloors.primaryColor)),
        ),
      ],
    );
  }

  // 🔹 Liste des ventes
  Widget _buildSalesList() {
    return Expanded(
      child: ListView.separated(
        itemCount: ventes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final vente = ventes[index];
          return _buildSaleCard(vente);
        },
      ),
    );
  }

  // 🔹 Carte de vente individuelle
  Widget _buildSaleCard(Map<String, String> vente) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(vente["date"]!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text("Enregistré: ${vente["heure"]!}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          if (vente["ventes"]!.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(vente["ventes"]!, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          ],
          const SizedBox(height: 5),
          Text("CA: ${vente["ca"]!}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
