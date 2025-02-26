import 'dart:convert';

class Journal {
  final int? id;
  final String? title;
  final String? price;
  final int? isActive;

  Journal({
    this.id,
    this.title,
    this.price,
    this.isActive,
  });

  // Convertir JSON en Objet Journal
  factory Journal.fromJson(Map<String, dynamic> json) {
    return Journal(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      isActive: json['is_active'],
    );
  }

  // Convertir Objet Journal en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'is_active': isActive
    };
  }

  // Convertir une liste JSON en liste d'objets Journal
  static List<Journal> fromJsonList(String str) {
    return List<Journal>.from(json.decode(str).map((x) => Journal.fromJson(x)));
  }
}