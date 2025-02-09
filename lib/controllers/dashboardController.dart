import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gls/helpers/launchReq.dart';
import 'package:gls/helpers/urls.dart';
import 'package:gls/screens/loginScreen.dart';
import 'package:gls/screens/venteListeScreen.dart';

class DashboardController extends GetxController {
  // Index de navigation (pour le BottomNavigationBar)
  var currentTabIndex = 0.obs;
  final LaunchReq api = LaunchReq();
  final GetStorage storage = GetStorage();


  // Données dynamiques du tableau de bord
  var user = {}.obs;
  var totalClients = 0.obs;
  var totalClientsActifs = 0.obs;
  var totalJournaux = 0.obs;
  var totalVentes = 0.obs;
  var stockRestant = 0.obs;
  var commerciaux = [].obs;
  var isLoading = false.obs; 

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData(); // Charger les données au démarrage
  }

  @override
  void onReady() {
    super.onReady();
  }

  // Changer d'onglet dans le BottomNavigationBar
  void changeTabIndex(int index) {
    currentTabIndex.value = index;
  }

 Future<void> fetchDashboardData() async {
  String? token = storage.read("token"); // 📌 Récupérer le token stocké

  if (token == null || token.isEmpty) {
    Fluttertoast.showToast(msg: "Session expirée. Veuillez vous reconnecter.", backgroundColor: Colors.red);
    Get.offAll(() => LoginScreen());
    return;
  }

  try {
    isLoading.value = true; // 📌 Afficher le loader
    var response = await api.getRequest(
      Urls.dashboardUrl,
      headers: {
        "Authorization": "Bearer $token", // 🔥 Ajout du token dans l'en-tête
        "Content-Type": "application/json",
      },
    );

    if (response.containsKey("error")) {
      Fluttertoast.showToast(msg: response["error"], backgroundColor: Colors.red);
      return;
    }

    // 📌 Stockage des données dans des variables observables
    user.value = response["user"] ?? {};
    totalClients.value = response["total_clients"] ?? 0;
    totalClientsActifs.value = response["total_clients_actifs"] ?? 0;
    totalJournaux.value = response["total_journaux"] ?? 0;
    totalVentes.value = response["total_ventes"] ?? 0;
    stockRestant.value = response["stock_restant"] ?? 0;

    // Vérifier si la liste de commerciaux est disponible
    if (response["commerciaux"] != null && response["commerciaux"] is List) {
      commerciaux.assignAll(response["commerciaux"].map((e) => e as Map<String, dynamic>).toList());
    } else {
      commerciaux.clear();
    }
    Fluttertoast.showToast(msg: "Données du tableau de bord chargées !", backgroundColor: Colors.green);
  } catch (e) {
    Fluttertoast.showToast(msg: "Erreur de connexion: $e", backgroundColor: Colors.red);
  } finally {
    isLoading.value = false; // 📌 Cacher le loader
  }
}

  // Fonction pour exporter la liste des commerciaux (simulée)
  void exporterListe() {
    Get.snackbar("Exportation", "Liste des commerciaux exportée avec succès !");
  }

  void goToVenteList(){
    Get.to(() => VenteListScreen());
  }

  // Fonction pour voir les performances des agents (simulée)
  void voirPerformances() {
    Get.snackbar("Performances", "Affichage des performances des agents...");
  }
}
