import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/dashboardController.dart';
import 'package:gls/controllers/usersController.dart';
import 'package:gls/helpers/coloors.dart';
import 'package:gls/screens/commerciauxScreen.dart';
import 'package:gls/screens/notificationsScreen.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());
  final UsersController usersController = Get.put(UsersController());

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tableau de bord"),
        centerTitle: true,
        backgroundColor: Coloors.primaryColor,
      ),
      body: Obx(() {
        if(controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserHeader(),
                const SizedBox(height: 15),
                _buildSectionTitle("Tableau de bord"),
                const SizedBox(height: 10),
                _buildDashboardStats(),
                const SizedBox(height: 20),
                _buildActionButton("Liste des ventes", Icons.list, controller.goToVenteList),
                const SizedBox(height: 10),
                _buildCompleteButton("Liste des points de ventes", Icons.list, controller.goToPointOfSale),
                const SizedBox(height: 20),
                _buildStockInfo(),
                const SizedBox(height: 20),
                _buildActionButtons(),
              ],
            ),
          );
        }
      ),
    );
  }

  /// 👤 **User Header with Notifications & Search**
  Widget _buildUserHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/images/user.webp"), // Placeholder image
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
            
            IconButton(
              icon: const Icon(Icons.search, color: Coloors.primaryColor),
              onPressed: () => Get.to(() => CommercialListScreen()),
            ),
            
          ],
        ),
      ],
    );
  }

  /// 🔠 **Section Title**
  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }

  /// 📊 **Dashboard Statistics**
  Widget _buildDashboardStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildStatCard("Total Commerciaux", controller.totalClients.value)),
        const SizedBox(width: 10),
        Expanded(child: _buildStatCard("Commerciaux Actifs", controller.totalClientsActifs.value)),
      ],
    );
  }

  /// 📌 **Reusable Statistic Card**
  Widget _buildStatCard(String title, int value) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 5),
          Text(value.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// 🏪 **Stock Information**
  Widget _buildStockInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Produits en Stocks"),
        const SizedBox(height: 10),
        _buildStatCardTot("Nombre Total", controller.totalJournaux),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildStatCard("Nombre de ventes", controller.totalVentes.value)),
            const SizedBox(width: 10),
            Expanded(child: _buildStatCard("Nombres restants", controller.totalJournaux.value - controller.totalVentes.value)),
          ],
        ),
      ],
    );
  }

  /// 🏷 **Total Statistic Card**
  Widget _buildStatCardTot(String title, RxInt value) {
    return Obx(() => Container(
          width: Get.width,
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 5),
              Text(value.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ));
  }

  /// 🔘 **Action Buttons**
  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton("Catalogue des journaux", Icons.file_copy, controller.goToJournalList),
        const SizedBox(height: 10),
        _buildActionButton("Exporter la liste des commerciaux", Icons.file_download, usersController.exportCommerciauxToPdf),
        const SizedBox(height: 10),
        _buildActionButton("Suivre les performances des agents", Icons.bar_chart, controller.voirPerformances),
        
      ],
    );
  }

  /// ✅ **Reusable Action Button**
  Widget _buildActionButton(String title, IconData icon, VoidCallback onPressed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon, color: Coloors.primaryColor),
                label: const Text("Voir plus", style: TextStyle(color: Coloors.primaryColor)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Coloors.primaryColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompleteButton(String title, IconData icon, VoidCallback onPressed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                ),
                icon: Icon(icon, color: Colors.white),
                label: const Text("Voir plus", style: TextStyle(color: Colors.white)),
                
              ),
            ),
          ],
        ),
      ],
    );
  }
}
