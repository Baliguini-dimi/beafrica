// lib/features/marketplace/data/marketplace_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../../models/product_model.dart';

class MarketplaceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  static const List<Map<String, String>> categories = [
    {'id': 'alimentaire', 'label': 'Alimentaire & Produits locaux'},
    {'id': 'artisanat', 'label': 'Artisanat & Art centrafricain'},
    {'id': 'services', 'label': 'Services'},
    {'id': 'vetements', 'label': 'Vêtements & Tenues traditionnelles'},
    {'id': 'electronique', 'label': 'Électronique & Divers'},
  ];

  Stream<List<ProductModel>> getProducts({String? category}) {
    Query query = _firestore
        .collection('products')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true);

    if (category != null && category != 'tous') {
      query = query.where('category', isEqualTo: category);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              ProductModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .where((p) => !p.isExpired)
          .toList();
    });
  }

  Stream<ProductModel?> getProduct(String productId) {
    return _firestore
        .collection('products')
        .doc(productId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return ProductModel.fromJson(doc.data()!, doc.id);
    });
  }

  Stream<List<ProductModel>> getSellerProducts(String sellerId) {
    return _firestore
        .collection('products')
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
          .toList();
    });
  }

  Future<String> createProduct(ProductModel product) async {
    final doc = await _firestore.collection('products').add(product.toJson());
    return doc.id;
  }

  Future<void> toggleProductStatus(String productId, bool isActive) async {
    await _firestore.collection('products').doc(productId).update({
      'isActive': isActive,
    });
  }

  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }

  Future<String> uploadImage(
      File imageFile, String productId, int index) async {
    final ref = _storage
        .ref()
        .child('products')
        .child(productId)
        .child('image_$index.jpg');
    final task = await ref.putFile(imageFile);
    return task.ref.getDownloadURL();
  }

  Future<void> reportProduct(String productId) async {
    await _firestore.collection('products').doc(productId).update({
      'reportCount': FieldValue.increment(1),
    });
  }
}
