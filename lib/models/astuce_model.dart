// lib/models/astuce_model.dart

class AstuceModel {
  final String id;
  final String title;
  final String content;
  final String updatedAt;

  const AstuceModel({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
  });

  factory AstuceModel.fromJson(Map<String, dynamic> json) {
    return AstuceModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      updatedAt: json['updated_at'] ?? json['updatedAt'] ?? '',
    );
  }
}

class AstuceCategoryModel {
  final String id;
  final String label;
  final String icon;
  final List<AstuceModel> articles;

  const AstuceCategoryModel({
    required this.id,
    required this.label,
    required this.icon,
    required this.articles,
  });

  factory AstuceCategoryModel.fromJson(Map<String, dynamic> json) {
    return AstuceCategoryModel(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      icon: json['icon'] ?? '',
      articles: (json['articles'] as List<dynamic>? ?? [])
          .map((e) => AstuceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
