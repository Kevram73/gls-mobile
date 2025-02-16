import 'dart:convert';

class PointOfSale {
  final int id;
  final String name;
  final String? address;
  final String city;
  final int isActive;
  final int ownerId;
  final String owner;

  PointOfSale({
    required this.id,
    required this.name,
    this.address,
    required this.city,
    required this.isActive,
    required this.ownerId,
    required this.owner,
  });

  factory PointOfSale.fromJson(Map<String, dynamic> json) {
    return PointOfSale(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      isActive: json['is_active'],
      ownerId: json['owner_id'],
      owner: json['owner'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'is_active': isActive,
      'owner_id': ownerId,
      'owner': owner,
    };
  }

  static List<PointOfSale> fromJsonList(String str) {
    return List<PointOfSale>.from(json.decode(str).map((x) => PointOfSale.fromJson(x)));
  }
}