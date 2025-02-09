import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class LaunchReq {
  final GetStorage storage = GetStorage();

  /// 🟢 **GET Request**
  Future<dynamic> getRequest(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: _mergeHeaders(headers),
      );
      return _processResponse(response);
    } catch (e) {
      return {"error": "Erreur de connexion: $e"};
    }
  }

  /// 🟡 **POST Request**
  Future<dynamic> postRequest(String endpoint, Map<String, dynamic> data, {Map<String, String>? headers}) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: _mergeHeaders(headers),
        body: jsonEncode(data),
      );
      return _processResponse(response);
    } catch (e) {
      return {"error": "Erreur de connexion: $e"};
    }
  }

  /// 🔵 **PUT Request**
  Future<dynamic> putRequest(String endpoint, Map<String, dynamic> data, {Map<String, String>? headers}) async {
    try {
      final response = await http.put(
        Uri.parse(endpoint),
        headers: _mergeHeaders(headers),
        body: jsonEncode(data),
      );
      return _processResponse(response);
    } catch (e) {
      return {"error": "Erreur de connexion: $e"};
    }
  }

  /// 🔴 **DELETE Request**
  Future<dynamic> deleteRequest(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await http.delete(
        Uri.parse(endpoint),
        headers: _mergeHeaders(headers),
      );
      return _processResponse(response);
    } catch (e) {
      return {"error": "Erreur de connexion: $e"};
    }
  }

  /// 🛠 **Generate Headers with Optional Custom Headers**
  Map<String, String> _mergeHeaders(Map<String, String>? customHeaders) {
    String? token = storage.read("token");
    
    Map<String, String> defaultHeaders = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    return {...defaultHeaders, ...?customHeaders}; // Merge with any provided headers
  }

  /// 🔍 **Handle HTTP Responses**
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      return {"error": "Erreur ${response.statusCode}: ${response.body}"};
    }
  }
}
