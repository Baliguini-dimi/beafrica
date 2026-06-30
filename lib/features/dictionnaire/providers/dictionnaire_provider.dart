// lib/features/dictionnaire/providers/dictionnaire_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/dictionary_entry_model.dart';
import '../data/dictionnaire_repository.dart';

final dictionnaireRepositoryProvider = Provider<DictionnaireRepository>((ref) {
  return DictionnaireRepository();
});

final dictionaryCategoriesProvider =
    FutureProvider<List<DictionaryCategoryModel>>((ref) {
  return ref.watch(dictionnaireRepositoryProvider).getCategories();
});

class DictionnaireSearchNotifier extends StateNotifier<String> {
  DictionnaireSearchNotifier() : super('');
  void search(String query) => state = query;
}

final dictionnaireSearchProvider =
    StateNotifierProvider<DictionnaireSearchNotifier, String>((ref) {
  return DictionnaireSearchNotifier();
});

// Favoris (local uniquement pour l'instant — clé SharedPreferences au Sprint 15)
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  void toggle(String entryId) {
    if (state.contains(entryId)) {
      state = {...state}..remove(entryId);
    } else {
      state = {...state, entryId};
    }
  }

  bool isFavorite(String entryId) => state.contains(entryId);
}

final dictionaryFavoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});
