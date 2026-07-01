// lib/models/cart_item_model.dart

class CartItemModel {
  final String productId;
  final String productTitle;
  final double price;
  final String? imageUrl;
  final String sellerName;
  final String sellerWhatsapp;
  int quantity;

  CartItemModel({
    required this.productId,
    required this.productTitle,
    required this.price,
    this.imageUrl,
    required this.sellerName,
    required this.sellerWhatsapp,
    this.quantity = 1,
  });

  double get subtotal => price * quantity;

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productTitle': productTitle,
        'price': price,
        'imageUrl': imageUrl,
        'sellerName': sellerName,
        'sellerWhatsapp': sellerWhatsapp,
        'quantity': quantity,
      };

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] ?? '',
      productTitle: json['productTitle'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'],
      sellerName: json['sellerName'] ?? '',
      sellerWhatsapp: json['sellerWhatsapp'] ?? '',
      quantity: json['quantity'] ?? 1,
    );
  }
}
