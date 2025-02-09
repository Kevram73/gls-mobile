import 'dart:convert';

class Vente {
  final int id;
  final DateTime date;
  final double montant;
  final int pointOfSaleId;
  final int? clientId;
  final int? journalId;
  final int nbre;
  final int sellerId;
  final bool isPaid;
  final DateTime? deletedAt;

  Vente({
    required this.id,
    required this.date,
    required this.montant,
    required this.pointOfSaleId,
    this.clientId,
    this.journalId,
    required this.nbre,
    required this.sellerId,
    required this.isPaid,
    this.deletedAt,
  });

  factory Vente.fromJson(Map<String, dynamic> json) {
    return Vente(
      id: json['id'],
      date: DateTime.parse(json['date']),
      montant: (json['montant'] as num).toDouble(),
      pointOfSaleId: json['point_of_sale_id'],
      clientId: json['client_id'],
      journalId: json['journal_id'],
      nbre: json['nbre'],
      sellerId: json['seller_id'],
      isPaid: json['is_paid'] ?? false,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'montant': montant,
      'point_of_sale_id': pointOfSaleId,
      'client_id': clientId,
      'journal_id': journalId,
      'nbre': nbre,
      'seller_id': sellerId,
      'is_paid': isPaid,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  static List<Vente> fromJsonList(String str) {
    return List<Vente>.from(json.decode(str).map((x) => Vente.fromJson(x)));
  }
}