// lib/features/marketplace/providers/cart_provider.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/cart_item_model.dart';
import '../../../models/product_model.dart';

class CartNotifier extends StateNotifier<List<CartItemModel>> {
  CartNotifier() : super([]) {
    _loadCart();
  }

  static const String _cartKey = 'cart_items';

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString(_cartKey);
    if (cartJson != null) {
      final list = jsonDecode(cartJson) as List<dynamic>;
      state = list
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_cartKey, cartJson);
  }

  void addProduct(ProductModel product) {
    final existingIndex =
        state.indexWhere((item) => item.productId == product.id);

    if (existingIndex >= 0) {
      state[existingIndex].quantity++;
      state = [...state];
    } else {
      state = [
        ...state,
        CartItemModel(
          productId: product.id,
          productTitle: product.title,
          price: product.price,
          imageUrl:
              product.imageUrls.isNotEmpty ? product.imageUrls.first : null,
          sellerName: product.sellerName,
          sellerWhatsapp: product.sellerWhatsapp,
        ),
      ];
    }
    _saveCart();
  }

  void removeProduct(String productId) {
    state = state.where((item) => item.productId != productId).toList();
    _saveCart();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }
    final index = state.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      state[index].quantity = quantity;
      state = [...state];
      _saveCart();
    }
  }

  void clearCart() {
    state = [];
    _saveCart();
  }

  double get total => state.fold(0, (sum, item) => sum + item.subtotal);

  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItemModel>>((ref) {
  return CartNotifier();
});
