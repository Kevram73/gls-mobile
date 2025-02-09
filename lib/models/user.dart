import 'dart:convert';

class User {
  final int id;
  final String nom;
  final String prenom;
  final String numPhone;
  final int typeUserId;
  final String email;
  final bool actif;
  final bool twoFactorEnabled;
  final bool isCommercial;
  final int? pointOfSaleId;
  final int stockJournal;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.numPhone,
    required this.typeUserId,
    required this.email,
    required this.actif,
    required this.twoFactorEnabled,
    required this.isCommercial,
    this.pointOfSaleId,
    required this.stockJournal,
  });

  // Convertir JSON en Objet User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      numPhone: json['num_phone'],
      typeUserId: json['type_user_id'],
      email: json['email'],
      actif: json['actif'] ?? false,
      twoFactorEnabled: json['two_factor_enabled'] ?? false,
      isCommercial: json['is_commercial'] ?? false,
      pointOfSaleId: json['point_of_sale_id'],
      stockJournal: json['stock_journal'] ?? 0,
    );
  }

  // Convertir Objet User en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'num_phone': numPhone,
      'type_user_id': typeUserId,
      'email': email,
      'actif': actif,
      'two_factor_enabled': twoFactorEnabled,
      'is_commercial': isCommercial,
      'point_of_sale_id': pointOfSaleId,
      'stock_journal': stockJournal,
    };
  }

  // Convertir une liste JSON en liste d'objets User
  static List<User> fromJsonList(String str) {
    return List<User>.from(json.decode(str).map((x) => User.fromJson(x)));
  }
}