import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:gls/helpers/launchReq.dart';
import 'package:gls/helpers/urls.dart';
import 'package:gls/models/point_of_sale.dart';
import 'package:gls/models/user.dart';

class PointOfSaleController extends GetxController {
  final LaunchReq apiClient = LaunchReq();
  final GetStorage storage = GetStorage();

  final RxList<PointOfSale> pointsOfSale = <PointOfSale>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxList<User> users = <User>[].obs;


  @override
  void onInit() {
    fetchPointsOfSale();
    getUsers();
    super.onInit();

  }

  Map<String, String> _authHeaders() {
    String? token = storage.read("token");
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<void> fetchPointsOfSale() async {
    final response = await apiClient.getRequest(Urls.pointOfSalesListUrl, headers: _authHeaders());

    if (response != null && response is List) {
      pointsOfSale.assignAll(response.map((json) => PointOfSale.fromJson(json)).toList());
      _showToast("Données chargées avec succès");
    } else {
      _showToast(response?["message"] ?? "Échec du chargement des points de vente", error: true);
    }
  }

  Future<void> addPointOfSale(PointOfSale pos) async {
    final response = await apiClient.postRequest(Urls.pointOfSalesListUrl, pos.toJson(), headers: _authHeaders());

    if (response != null && response["error"] == null) {
      pointsOfSale.add(PointOfSale.fromJson(response));
      _showToast(response["message"] ?? "Point de vente ajouté avec succès");
    } else {
      _showToast(response?["message"] ?? "Impossible d'ajouter le point de vente", error: true);
    }
  }

  Future<void> editPointOfSale(int id, PointOfSale updatedPos) async {
    final response = await apiClient.putRequest(
      Urls.updatePointOfSaleUrl.replaceFirst("{id}", id.toString()),
      updatedPos.toJson(),
      headers: _authHeaders(),
    );

    if (response != null && response["error"] == null) {
      int index = pointsOfSale.indexWhere((pos) => pos.id == id);
      if (index != -1) {
        pointsOfSale[index] = PointOfSale.fromJson(response);
        _showToast(response["message"] ?? "Point de vente mis à jour");
      }
    } else {
      _showToast(response?["message"] ?? "Échec de la mise à jour", error: true);
    }
  }

  Future<void> deletePointOfSale(int id) async {
    final response = await apiClient.deleteRequest(
      Urls.deletePointOfSaleUrl.replaceFirst("{id}", id.toString()),
      headers: _authHeaders(),
    );

    if (response != null && response["error"] == null) {
      pointsOfSale.removeWhere((pos) => pos.id == id);
      _showToast(response["message"] ?? "Point de vente supprimé");
    } else {
      _showToast(response?["message"] ?? "Impossible de supprimer le point de vente", error: true);
    }
  }

  Future<void> getUsers() async {
    final response = await apiClient.getRequest(
      Urls.pointOfSaleUsersUrl,
      headers: _authHeaders(),
    );

    if (response != null && response["error"] == null) {
      users.assignAll(response.map((json) => User.fromJson(json)).toList());
      _showToast(response["message"] ?? "Point de vente supprimé");
    } else {
      _showToast(response?["message"] ?? "Impossible de supprimer le point de vente", error: true);
    }
  }

  List<PointOfSale> get filteredPoints {
    return pointsOfSale.where((pos) {
      return pos.name.toLowerCase().contains(searchQuery.value) ||
             (pos.owner.toLowerCase() ?? "").contains(searchQuery.value);
    }).toList();
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
