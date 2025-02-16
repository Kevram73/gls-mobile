import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gls/helpers/launchReq.dart';
import 'package:gls/helpers/urls.dart';
import 'package:gls/models/user.dart';
import 'package:gls/screens/loginScreen.dart';
import 'package:gls/screens/pointOfSaleListScreen.dart';
import 'package:gls/screens/venteListeScreen.dart';

class DashboardController extends GetxController {
  // Index de navigation (pour le BottomNavigationBar)
  var currentTabIndex = 0.obs;
  final LaunchReq api = LaunchReq();
  final GetStorage storage = GetStorage();


  // Données dynamiques du tableau de bord
  var user = Rxn<User>();
  var totalClients = 0.obs;
  var totalClientsActifs = 0.obs;
  var totalJournaux = 0.obs;
  var totalVentes = 0.obs;
  var stockRestant = 0.obs;
  var commerciaux = [].obs;
  var isLoading = false.obs; 
  var userImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData(); // Charger les données au démarrage
  }


  // Changer d'onglet dans le BottomNavigationBar
  void changeTabIndex(int index) {
    currentTabIndex.value = index;
  }

 Future<void> fetchDashboardData() async {
  String? token = storage.read("token"); // 📌 Récupérer le token stocké

  if (token == null || token.isEmpty) {
    Fluttertoast.showToast(msg: "Session expirée. Veuillez vous reconnecter.", backgroundColor: Colors.red);
    Get.offAll(() => const LoginScreen());
    return;
  }

  try {
    isLoading.value = true; // 📌 Afficher le loader
    var response = await api.postRequest(
      Urls.dashboardUrl,
      {},
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
    if (response["user"] != null){
      user.value = User.fromJson(response["user"]);
    }
    
    totalClients.value = response["total_clients"];
    totalClientsActifs.value = response["total_clients_actifs"];
    totalJournaux.value = response["total_journaux"];
    totalVentes.value = response["total_ventes"];
    stockRestant.value = response["stock_restant"];

    // Vérifier si la liste de commerciaux est disponible
    // if (response["commerciaux"] != null && response["commerciaux"] is List) {
    //   commerciaux.assignAll(response["commerciaux"].map((e) => e as Map<String, dynamic>).toList());
    // } else {
    //   commerciaux.clear();
    // }
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
    Get.to(() => const VenteListScreen());
  }

  void goToPointOfSale(){
    Get.to(() => PointOfSaleListScreen());
  }

  // Fonction pour voir les performances des agents (simulée)
  void voirPerformances() {
    Get.snackbar("Performances", "Affichage des performances des agents...");
  }

  Future<void> changePassword(String oldPassword, String newPassword, String confirmPassword) async {
    String? token = storage.read("token");
    if (token == null || token.isEmpty) {
      Get.snackbar("Erreur", "Session expirée. Veuillez vous reconnecter.", backgroundColor: Colors.red);
      return;
    }
    log("oldPassword: $oldPassword, newPassword: $newPassword, confirmPassword: $confirmPassword");

    try{
      isLoading.value = true;
    var response = await api.postRequest(
      Urls.changePasswordUrl,
      {"old_password": oldPassword, "new_password": newPassword, "confirm_password": confirmPassword},
      headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
    );
    log("response: $response");
    Fluttertoast.showToast(msg: response["message"], backgroundColor: Colors.green);
    Get.back();
    }
    catch(e){
      Fluttertoast.showToast(msg: "Mot de passe incorrect", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
    

  }

  void logout() {
    storage.remove("token");
    Get.offAll(() => const LoginScreen());
  }


}
