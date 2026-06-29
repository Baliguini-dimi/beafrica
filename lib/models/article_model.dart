// lib/models/article_model.dart

class ArticleModel {
  final String id;
  final String title;
  final String summary;
  final String url;
  final String? imageUrl;
  final String sourceName;
  final bool isPartner;
  final String category;
  final DateTime publishedAt;

  const ArticleModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.url,
    this.imageUrl,
    required this.sourceName,
    this.isPartner = false,
    required this.category,
    required this.publishedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['image_url'],
      sourceName: json['source_name'] ?? '',
      isPartner: json['is_partner'] == 1,
      category: json['category'] ?? 'general',
      publishedAt:
          DateTime.tryParse(json['published_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'summary': summary,
        'url': url,
        'image_url': imageUrl,
        'source_name': sourceName,
        'is_partner': isPartner ? 1 : 0,
        'category': category,
        'published_at': publishedAt.toIso8601String(),
      };
}
