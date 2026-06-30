// lib/features/astuces/providers/astuces_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/astuce_model.dart';
import '../data/astuces_repository.dart';

final astucesRepositoryProvider = Provider<AstucesRepository>((ref) {
  return AstucesRepository();
});

final astucesCategoriesProvider =
    FutureProvider<List<AstuceCategoryModel>>((ref) {
  return ref.watch(astucesRepositoryProvider).getCategories();
});

class AstucesSearchNotifier extends StateNotifier<String> {
  AstucesSearchNotifier() : super('');

  void search(String query) => state = query;
}

final astucesSearchProvider =
    StateNotifierProvider<AstucesSearchNotifier, String>((ref) {
  return AstucesSearchNotifier();
});
