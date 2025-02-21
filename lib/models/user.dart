class User {
  final int? id;
  final String? nom;
  final String? prenom;
  final String? numPhone;
  final int? typeUserId;
  final String? email;
  final bool? actif;
  final int? pointOfSaleId;
  final bool? isCommercial;
  final int? stockJournal;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    this.nom,
    this.prenom,
    this.numPhone,
    this.typeUserId,
    this.email,
    this.actif,
    this.pointOfSaleId,
    this.isCommercial,
    this.stockJournal,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      numPhone: json['num_phone'],
      typeUserId: json['type_user_id'],
      email: json['email'],
      actif: json['actif'] == true,
      pointOfSaleId: json['point_of_sale_id'],
      isCommercial: json['is_commercial'] == true,
      stockJournal: json['stock_journal'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}