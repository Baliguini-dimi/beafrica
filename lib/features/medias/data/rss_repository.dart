// lib/features/medias/data/rss_repository.dart
import 'package:dart_rss/dart_rss.dart';
import 'package:dio/dio.dart';
import '../../../models/article_model.dart';
import '../../../shared/services/cache_service.dart';
import 'rss_sources.dart';

class RssRepository {
  final Dio _dio = Dio();
  final CacheService _cache;

  RssRepository(this._cache);

  Future<List<ArticleModel>> fetchArticles() async {
    final List<ArticleModel> allArticles = [];

    for (final source in RssSources.sources) {
      try {
        final response = await _dio.get(
          source['url']!,
          options: Options(
            responseType: ResponseType.plain,
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'User-Agent': 'BéAfrica/1.0',
            },
          ),
        );

        final feed = RssFeed.parse(response.data as String);

        for (final item in feed.items) {
          if (item.title == null) continue;
          allArticles.add(ArticleModel(
            id: item.guid ?? item.link ?? item.title!,
            title: item.title!,
            summary: item.description ?? '',
            url: item.link ?? '',
            imageUrl: _extractImage(item),
            sourceName: source['name']!,
            isPartner: source['isPartner'] == 'true',
            category: source['category'] ?? 'general',
            publishedAt: _parseDate(item.pubDate),
          ));
        }
      } catch (e) {
        continue;
      }
    }

    // Trier par date décroissante
    allArticles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

    // Mettre en cache les 50 premiers
    if (allArticles.isNotEmpty) {
      await _cache.saveArticles(
        allArticles.take(50).map((a) => a.toJson()).toList(),
      );
    }

    return allArticles;
  }

  Future<List<ArticleModel>> getCachedArticles() async {
    final cached = await _cache.getArticles();
    return cached.map((json) => ArticleModel.fromJson(json)).toList();
  }

  String? _extractImage(RssItem item) {
    if (item.enclosure?.url != null) return item.enclosure!.url;
    if (item.media?.contents?.isNotEmpty == true) {
      return item.media!.contents!.first.url;
    }
    return null;
  }

  DateTime _parseDate(String? pubDate) {
    if (pubDate == null) return DateTime.now();
    try {
      // Format RSS : "Mon, 01 Jan 2024 00:00:00 +0000"
      return DateTime.parse(pubDate);
    } catch (_) {
      return DateTime.now();
    }
  }
}
