// lib/features/marketplace/providers/marketplace_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/product_model.dart';
import '../data/marketplace_repository.dart';

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) {
  return MarketplaceRepository();
});

final productsProvider =
    StreamProvider.family<List<ProductModel>, String?>((ref, category) {
  return ref.watch(marketplaceRepositoryProvider).getProducts(
        category: category,
      );
});

final productDetailProvider =
    StreamProvider.family<ProductModel?, String>((ref, productId) {
  return ref.watch(marketplaceRepositoryProvider).getProduct(productId);
});

final sellerProductsProvider =
    StreamProvider.family<List<ProductModel>, String>((ref, sellerId) {
  return ref.watch(marketplaceRepositoryProvider).getSellerProducts(sellerId);
});

class MarketplaceCategoryNotifier extends StateNotifier<String> {
  MarketplaceCategoryNotifier() : super('tous');
  void setCategory(String category) => state = category;
}

final marketplaceCategoryProvider =
    StateNotifierProvider<MarketplaceCategoryNotifier, String>((ref) {
  return MarketplaceCategoryNotifier();
});

class MarketplaceSearchNotifier extends StateNotifier<String> {
  MarketplaceSearchNotifier() : super('');
  void search(String query) => state = query;
}

final marketplaceSearchProvider =
    StateNotifierProvider<MarketplaceSearchNotifier, String>((ref) {
  return MarketplaceSearchNotifier();
});
