import 'dart:convert';

class TypeUser {
  final int? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TypeUser({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  // Convertir JSON en Objet TypeUser
  factory TypeUser.fromJson(Map<String, dynamic> json) {
    return TypeUser(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  // Convertir Objet TypeUser en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    
    };
  }

  // Convertir une liste JSON en liste d'objets TypeUser
  static List<TypeUser> fromJsonList(String str) {
    return List<TypeUser>.from(json.decode(str).map((x) => TypeUser.fromJson(x)));
  }
}