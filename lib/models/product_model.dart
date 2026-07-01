// lib/models/product_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final List<String> imageUrls;
  final String city;
  final String sellerId;
  final String sellerName;
  final String sellerWhatsapp;
  final bool isActive;
  final DateTime createdAt;
  final DateTime expiresAt;
  final int reportCount;
  final bool isVerifiedSeller;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrls,
    required this.city,
    required this.sellerId,
    required this.sellerName,
    required this.sellerWhatsapp,
    this.isActive = true,
    required this.createdAt,
    required this.expiresAt,
    this.reportCount = 0,
    this.isVerifiedSeller = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, String id) {
    return ProductModel(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      city: json['city'] ?? '',
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      sellerWhatsapp: json['sellerWhatsapp'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: (json['expiresAt'] as Timestamp?)?.toDate() ??
          DateTime.now().add(const Duration(days: 30)),
      reportCount: json['reportCount'] ?? 0,
      isVerifiedSeller: json['isVerifiedSeller'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'price': price,
        'category': category,
        'imageUrls': imageUrls,
        'city': city,
        'sellerId': sellerId,
        'sellerName': sellerName,
        'sellerWhatsapp': sellerWhatsapp,
        'isActive': isActive,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 30)),
        ),
        'reportCount': reportCount,
        'isVerifiedSeller': isVerifiedSeller,
      };

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
