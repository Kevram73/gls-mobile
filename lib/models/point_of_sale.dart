import 'dart:convert';

class PointOfSale {
  final int? id;
  final String? name;
  final String? address;
  final String? city;
  final bool? isActive;
  final int? ownerId;
  final String? owner;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PointOfSale({
    this.id,
    this.name,
    this.address,
    this.city,
    this.isActive,
    this.ownerId,
    this.owner,
    this.createdAt,
    this.updatedAt
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
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  static List<PointOfSale> fromJsonList(String str) {
    return List<PointOfSale>.from(json.decode(str).map((x) => PointOfSale.fromJson(x)));
  }
}