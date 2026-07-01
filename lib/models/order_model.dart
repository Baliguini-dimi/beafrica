// lib/models/order_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus { pending, confirmed, delivered, cancelled }

class OrderModel {
  final String id;
  final String productId;
  final String productTitle;
  final String buyerId;
  final String buyerName;
  final String buyerPhone;
  final String buyerAddress;
  final String? buyerNote;
  final int quantity;
  final double totalPrice;
  final OrderStatus status;
  final String sellerId;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.productId,
    required this.productTitle,
    required this.buyerId,
    required this.buyerName,
    required this.buyerPhone,
    required this.buyerAddress,
    this.buyerNote,
    required this.quantity,
    required this.totalPrice,
    this.status = OrderStatus.pending,
    required this.sellerId,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, String id) {
    return OrderModel(
      id: id,
      productId: json['productId'] ?? '',
      productTitle: json['productTitle'] ?? '',
      buyerId: json['buyerId'] ?? '',
      buyerName: json['buyerName'] ?? '',
      buyerPhone: json['buyerPhone'] ?? '',
      buyerAddress: json['buyerAddress'] ?? '',
      buyerNote: json['buyerNote'],
      quantity: json['quantity'] ?? 1,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      sellerId: json['sellerId'] ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productTitle': productTitle,
    'buyerId': buyerId,
    'buyerName': buyerName,
    'buyerPhone': buyerPhone,
    'buyerAddress': buyerAddress,
    'buyerNote': buyerNote,
    'quantity': quantity,
    'totalPrice': totalPrice,
    'status': status.name,
    'sellerId': sellerId,
    'createdAt': FieldValue.serverTimestamp(),
  };

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:
        return 'En attente';
      case OrderStatus.confirmed:
        return 'Confirmée';
      case OrderStatus.delivered:
        return 'Livrée';
      case OrderStatus.cancelled:
        return 'Annulée';
    }
  }
}
