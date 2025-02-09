import 'dart:convert';

class Journal {
  final int id;
  final String title;
  final double price;
  final bool isActive;
  final DateTime? deletedAt;

  Journal({
    required this.id,
    required this.title,
    required this.price,
    required this.isActive,
    this.deletedAt,
  });

  // Convertir JSON en Objet Journal
  factory Journal.fromJson(Map<String, dynamic> json) {
    return Journal(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      isActive: json['is_active'] ?? false,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  // Convertir Objet Journal en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'is_active': isActive,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  // Convertir une liste JSON en liste d'objets Journal
  static List<Journal> fromJsonList(String str) {
    return List<Journal>.from(json.decode(str).map((x) => Journal.fromJson(x)));
  }
}