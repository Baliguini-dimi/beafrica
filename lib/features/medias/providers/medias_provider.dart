// lib/features/medias/providers/medias_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/article_model.dart';
import '../../../shared/services/cache_service.dart';
import '../data/rss_repository.dart';

final rssRepositoryProvider = Provider<RssRepository>((ref) {
  return RssRepository(ref.watch(cacheServiceProvider));
});

class MediasState {
  final List<ArticleModel> articles;
  final List<ArticleModel> filteredArticles;
  final bool isLoading;
  final String? error;
  final String selectedCategory;
  final bool isOffline;

  const MediasState({
    this.articles = const [],
    this.filteredArticles = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategory = 'tous',
    this.isOffline = false,
  });

  MediasState copyWith({
    List<ArticleModel>? articles,
    List<ArticleModel>? filteredArticles,
    bool? isLoading,
    String? error,
    String? selectedCategory,
    bool? isOffline,
  }) {
    return MediasState(
      articles: articles ?? this.articles,
      filteredArticles: filteredArticles ?? this.filteredArticles,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

class MediasNotifier extends StateNotifier<MediasState> {
  final RssRepository _repository;

  MediasNotifier(this._repository) : super(const MediasState()) {
    loadArticles();
  }

  Future<void> loadArticles() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final articles = await _repository.fetchArticles();
      state = state.copyWith(
        articles: articles,
        filteredArticles: articles,
        isLoading: false,
        isOffline: false,
      );
    } catch (e) {
      // Essayer le cache
      try {
        final cached = await _repository.getCachedArticles();
        if (cached.isNotEmpty) {
          state = state.copyWith(
            articles: cached,
            filteredArticles: cached,
            isLoading: false,
            isOffline: true,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            error: 'Impossible de charger les actualités',
          );
        }
      } catch (_) {
        state = state.copyWith(
          isLoading: false,
          error: 'Impossible de charger les actualités',
        );
      }
    }
  }

  void filterByCategory(String category) {
    final filtered = category == 'tous'
        ? state.articles
        : state.articles.where((a) => a.category == category).toList();

    state = state.copyWith(
      selectedCategory: category,
      filteredArticles: filtered,
    );
  }

  void search(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredArticles: state.articles);
      return;
    }
    final filtered = state.articles
        .where((a) =>
            a.title.toLowerCase().contains(query.toLowerCase()) ||
            a.sourceName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    state = state.copyWith(filteredArticles: filtered);
  }
}

final mediasProvider =
    StateNotifierProvider<MediasNotifier, MediasState>((ref) {
  return MediasNotifier(ref.watch(rssRepositoryProvider));
});
