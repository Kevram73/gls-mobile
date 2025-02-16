class User {
  final int id;
  final String nom;
  final String prenom;
  final String numPhone;
  final int typeUserId;
  final String email;
  final bool actif;
  final int? pointOfSaleId;
  final bool isCommercial;
  final int stockJournal;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.numPhone,
    required this.typeUserId,
    required this.email,
    required this.actif,
    this.pointOfSaleId,
    required this.isCommercial,
    required this.stockJournal,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      numPhone: json['num_phone'],
      typeUserId: json['type_user_id'],
      email: json['email'],
      actif: json['actif'] == 1,
      pointOfSaleId: json['point_of_sale_id'],
      isCommercial: json['is_commercial'],
      stockJournal: json['stock_journal'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}