import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/dashboardController.dart';
import 'package:gls/controllers/venteController.dart';
import 'package:gls/helpers/coloors.dart';
import 'package:gls/models/vente.dart';
import 'package:gls/screens/commerciauxScreen.dart';
import 'package:gls/screens/detailsVenteScreen.dart';
import 'package:gls/screens/notificationsScreen.dart';
import 'package:gls/screens/venteListeScreen.dart';

class DashAgentScreen extends StatelessWidget {
  final VenteController venteController = Get.put(VenteController());
  final DashboardController controller = Get.put(DashboardController());

  DashAgentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text("Tableau de bord"),
        centerTitle: true,
        backgroundColor: Coloors.primaryColor,
      ),
      body: Obx(() {
        if (venteController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserHeader(),
              const SizedBox(height: 15),
              _buildDashboardStats(),
              const SizedBox(height: 20),
              _buildRecentSales(),
            ],
          ),
        );
      })
    );
  }

  Widget _buildUserHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/images/user.webp"),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${controller.user.value!.nom} ${controller.user.value!.prenom}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Text("Bienvenue !", style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ],
        ),
        Row(
          children: [
            
           
          ],
        ),
      ],
    );
  }

  Widget _buildDashboardStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildStatCard("Total des ventes", venteController.ventes.length.toString())),
        const SizedBox(width: 10),
        Expanded(child: _buildStatCard("Plaintes soumises", controller.totalPlaintes.toString())),
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.black)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRecentSales() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Ventes récentes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            InkWell(onTap: (){Get.to(() => VenteListScreen());}, child: Text("Voir tout", style: TextStyle(fontSize: 16, color: Coloors.primaryColor))),
          ],
        ),
        const SizedBox(height: 10),
        _buildSearchBar(),
        ...venteController.ventes.map((vente) => _buildSaleItem(vente.montant!, "${vente.nbre} journal(s)", vente.date!, vente)),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Rechercher",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildSaleItem(String price, String quantity, DateTime date, Vente vente) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Vente journal", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(price, style: const TextStyle(fontSize: 14)),
              Text("${date.year}-${date.month}-${date.day} | $quantity", style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              Get.to(() => DetailsVenteScreen(vente: vente));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Coloors.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text("Voir plus", style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(width: 10),

        ],
      ),
    );
  }
}