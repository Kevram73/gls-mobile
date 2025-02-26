import 'dart:convert';
import 'package:gls/models/point_of_sale.dart';
import 'package:gls/models/user.dart';

class Vente {
  final int? id;
  final DateTime? date;
  final String? montant;
  final int? pointOfSaleId;
  final int? clientId;
  final int? journalId;
  final int? nbre;
  final int? sellerId;
  final bool? isPaid;
  final PointOfSale? pointOfSale;
  final User? client;
  final User? seller;

  Vente({
    this.id,
    this.date,
    this.montant,
    this.pointOfSaleId,
    this.clientId,
    this.journalId,
    this.nbre,
    this.sellerId,
    this.isPaid,
    this.pointOfSale,
    this.client,
    this.seller,
  });

  factory Vente.fromJson(Map<String, dynamic> json) {
    return Vente(
      id: json['id'] as int?,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      montant: json['montant'] as String?,
      pointOfSaleId: json['point_of_sale_id'] as int?,
      clientId: json['client_id'] as int?,
      journalId: json['journal_id'] as int?,
      nbre: json['nbre'] as int?,
      sellerId: json['seller_id'] as int?,
      isPaid: json['is_paid'] as bool?,
      pointOfSale: json['point_of_sale'] != null ? PointOfSale.fromJson(json['point_of_sale']) : null,
      client: json['client'] != null ? User.fromJson(json['client']) : null,
      seller: json['seller'] != null ? User.fromJson(json['seller']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'montant': montant,
      'point_of_sale_id': pointOfSaleId,
      'client_id': clientId,
      'journal_id': journalId,
      'nbre': nbre,
      'seller_id': sellerId,
      'is_paid': isPaid,
      'point_of_sale': pointOfSale?.toJson(),
      'client': client?.toJson(),
      'seller': seller?.toJson(),
    };
  }

  static List<Vente> fromJsonList(String str) {
    final jsonData = json.decode(str);
    return List<Vente>.from(jsonData.map((x) => Vente.fromJson(x)));
  }
}
