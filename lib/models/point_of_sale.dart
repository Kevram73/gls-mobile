import 'dart:convert';

class PointOfSale {
  final int id;
  final String name;
  final String? address;
  final String city;
  final double? latitude;
  final double? longitude;
  final bool isActive;
  final DateTime? deletedAt;

  PointOfSale({
    required this.id,
    required this.name,
    this.address,
    required this.city,
    this.latitude,
    this.longitude,
    required this.isActive,
    this.deletedAt,
  });

  factory PointOfSale.fromJson(Map<String, dynamic> json) {
    return PointOfSale(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      isActive: json['is_active'] ?? false,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'is_active': isActive,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  static List<PointOfSale> fromJsonList(String str) {
    return List<PointOfSale>.from(json.decode(str).map((x) => PointOfSale.fromJson(x)));
  }
}