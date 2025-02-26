import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gls/helpers/launchReq.dart';
import 'package:gls/helpers/urls.dart';
import 'package:gls/models/journal.dart';
import 'package:gls/models/user.dart';
import 'package:gls/models/vente.dart';

class VenteController extends GetxController {
  final LaunchReq apiClient = LaunchReq();
  final GetStorage storage = GetStorage();

  final RxList<Vente> ventes = <Vente>[].obs;
  final RxList<User> clients = <User>[].obs;
  final RxList<Journal> journals = <Journal>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final String storageKey = 'ventes';

  @override
  void onInit() {
    super.onInit();
    loadVentes();
    fetchJournals();
    fetchVentes();
    fetchClients();
  }

  Map<String, String> _authHeaders() {
    String? token = storage.read("token");
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<void> fetchVentes() async {
    isLoading.value = true;
    final response = await apiClient.getRequest(Urls.ventesListUrl, headers: _authHeaders());
    isLoading.value = false;

    if (response != null && response is List) {
      ventes.assignAll(response.map((json) => Vente.fromJson(json)).toList());
    } else {
      _showToast(response?["message"] ?? "Erreur lors du chargement des ventes", error: true);
    }
  }

  Future<void> fetchJournals() async {
    isLoading.value = true;
    final response = await apiClient.getRequest(Urls.journalsListUrl, headers: _authHeaders());
    isLoading.value = false;

    if (response != null && response is List) {
      journals.assignAll(response.map((json) => Journal.fromJson(json)).toList());
    } else {
      _showToast(response?["message"] ?? "Erreur lors du chargement des journaux", error: true);
    }
  }

  Future<void> fetchClients() async {
    isLoading.value = true;
    final response = await apiClient.getRequest(Urls.usersListUrl, headers: _authHeaders());
    isLoading.value = false;

    if (response != null && response is List) {
      clients.assignAll(response.map((json) => User.fromJson(json)).toList());
    } else {
      _showToast(response?["message"] ?? "Erreur lors du chargement des ventes", error: true);
    }
  }

  void loadVentes() {
    List<dynamic>? storedVentes = storage.read<List<dynamic>>(storageKey);
    if (storedVentes != null) {
      ventes.assignAll(storedVentes.map((json) => Vente.fromJson(json)).toList());
    }
  }

  void saveVentes() {
    storage.write(storageKey, ventes.map((vente) => vente.toJson()).toList());
  }

  Future<void> addVente(Vente vente) async {
    final response = await apiClient.postRequest(Urls.ventesListUrl, vente.toJson(), headers: _authHeaders());

    if (response != null && response["error"] == null) {
      ventes.add(Vente.fromJson(response));
      saveVentes();
      _showToast(response["message"] ?? "Vente ajoutée avec succès");
    } else {
      _showToast(response?["message"] ?? "Impossible d'ajouter la vente", error: true);
    }
  }

  Future<void> editVente(int id, Vente updatedVente) async {
    final response = await apiClient.putRequest(
      Urls.updateVenteUrl.replaceFirst("{id}", id.toString()),
      updatedVente.toJson(),
      headers: _authHeaders(),
    );

    if (response != null && response["error"] == null) {
      int index = ventes.indexWhere((vente) => vente.id == id);
      if (index != -1) {
        ventes[index] = Vente.fromJson(response);
        saveVentes();
        _showToast(response["message"] ?? "Vente mise à jour");
      }
    } else {
      _showToast(response?["message"] ?? "Échec de la mise à jour", error: true);
    }
  }

  Future<void> deleteVente(int id) async {
    final response = await apiClient.deleteRequest(
      Urls.deleteVenteUrl.replaceFirst("{id}", id.toString()),
      headers: _authHeaders(),
    );

    if (response != null && response["error"] == null) {
      ventes.removeWhere((vente) => vente.id == id);
      saveVentes();
      _showToast(response["message"] ?? "Vente supprimée");
    } else {
      _showToast(response?["message"] ?? "Impossible de supprimer la vente", error: true);
    }
  }

  List<Vente> get filteredVentes {
    return ventes.where((vente) {
      return vente.pointOfSaleId.toString().contains(searchQuery.value) ||
             vente.sellerId.toString().contains(searchQuery.value) ||
             (vente.isPaid! ? "payé" : "non payé").contains(searchQuery.value);
    }).toList();
  }

  String formattedDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }

  void _showToast(String message, {bool error = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: error ? const Color(0xFFD32F2F) : const Color(0xFF4CAF50),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
