import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gls/helpers/launchReq.dart';
import 'package:gls/helpers/urls.dart';
import 'package:gls/models/journal.dart';

class JournalController extends GetxController {
  final LaunchReq apiClient = LaunchReq();
  final GetStorage storage = GetStorage();

  final RxList<Journal> journals = <Journal>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final String storageKey = 'journals';

  @override
  void onInit() {
    super.onInit();
    loadJournals();  // Charger les journaux depuis GetStorage
    fetchJournals(); // Récupérer depuis l'API
  }

  Map<String, String> _authHeaders() {
    String? token = storage.read("token");
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  /// **📥 Récupérer les journaux depuis l'API**
  Future<void> fetchJournals() async {
    isLoading.value = true;
    final response = await apiClient.getRequest(Urls.journalsListUrl, headers: _authHeaders());
    isLoading.value = false;

    if (response != null && response is List) {
      journals.assignAll(response.map((json) => Journal.fromJson(json)).toList());
      saveJournals();
    } else {
      _showToast(response?["message"] ?? "Erreur lors du chargement des journaux", error: true);
    }
  }

  /// **💾 Charger les journaux depuis GetStorage**
  void loadJournals() {
    List<dynamic>? storedJournals = storage.read<List<dynamic>>(storageKey);
    if (storedJournals != null) {
      journals.assignAll(storedJournals.map((json) => Journal.fromJson(json)).toList());
    }
  }

  /// **💾 Sauvegarder les journaux dans GetStorage**
  void saveJournals() {
    storage.write(storageKey, journals.map((journal) => journal.toJson()).toList());
  }

  /// **➕ Ajouter un journal**
  Future<void> addJournal(String title, double price, bool isActive) async {
    final newJournal = Journal(
      id: DateTime.now().millisecondsSinceEpoch, // ID temporaire
      title: title,
      price: price,
      isActive: isActive,
      deletedAt: null,
    );

    final response = await apiClient.postRequest(Urls.journalsListUrl, newJournal.toJson(), headers: _authHeaders());

    if (response != null && response["error"] == null) {
      journals.add(Journal.fromJson(response));
      saveJournals();
      _showToast(response["message"] ?? "Journal ajouté avec succès");
    } else {
      _showToast(response?["message"] ?? "Impossible d'ajouter le journal", error: true);
    }
  }

  /// **✏ Modifier un journal**
  Future<void> editJournal(int id, String newTitle, double newPrice, bool isActive) async {
    final updatedJournal = Journal(
      id: id,
      title: newTitle,
      price: newPrice,
      isActive: isActive,
      deletedAt: null,
    );

    final response = await apiClient.putRequest(
      Urls.updateJournalUrl.replaceFirst("{id}", id.toString()),
      updatedJournal.toJson(),
      headers: _authHeaders(),
    );

    if (response != null && response["error"] == null) {
      int index = journals.indexWhere((journal) => journal.id == id);
      if (index != -1) {
        journals[index] = Journal.fromJson(response);
        saveJournals();
        _showToast(response["message"] ?? "Journal mis à jour");
      }
    } else {
      _showToast(response?["message"] ?? "Échec de la mise à jour", error: true);
    }
  }

  /// **❌ Supprimer un journal**
  Future<void> deleteJournal(int id) async {
    final response = await apiClient.deleteRequest(
      Urls.deleteJournalUrl.replaceFirst("{id}", id.toString()),
      headers: _authHeaders(),
    );

    if (response != null && response["error"] == null) {
      journals.removeWhere((journal) => journal.id == id);
      saveJournals();
      _showToast(response["message"] ?? "Journal supprimé");
    } else {
      _showToast(response?["message"] ?? "Impossible de supprimer le journal", error: true);
    }
  }

  /// **🔍 Filtrer les journaux selon le titre**
  List<Journal> get filteredJournals {
    return journals.where((journal) {
      return journal.title.toLowerCase().contains(searchQuery.value);
    }).toList();
  }

  /// **🍞 Afficher un message toast**
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
