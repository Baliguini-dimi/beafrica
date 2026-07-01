// lib/models/forum_post_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ForumPostModel {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final String theme;
  final String authorId;
  final String authorName;
  final String? authorCountry;
  final int likes;
  final int supports;
  final int infos;
  final int replyCount;
  final int reportCount;
  final DateTime createdAt;

  const ForumPostModel({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.theme,
    required this.authorId,
    required this.authorName,
    this.authorCountry,
    this.likes = 0,
    this.supports = 0,
    this.infos = 0,
    this.replyCount = 0,
    this.reportCount = 0,
    required this.createdAt,
  });

  factory ForumPostModel.fromJson(Map<String, dynamic> json, String id) {
    return ForumPostModel(
      id: id,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'],
      theme: json['theme'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      authorCountry: json['authorCountry'],
      likes: json['likes'] ?? 0,
      supports: json['supports'] ?? 0,
      infos: json['infos'] ?? 0,
      replyCount: json['replyCount'] ?? 0,
      reportCount: json['reportCount'] ?? 0,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'imageUrl': imageUrl,
        'theme': theme,
        'authorId': authorId,
        'authorName': authorName,
        'authorCountry': authorCountry,
        'likes': likes,
        'supports': supports,
        'infos': infos,
        'replyCount': replyCount,
        'reportCount': reportCount,
        'createdAt': FieldValue.serverTimestamp(),
      };
}

class ForumReplyModel {
  final String id;
  final String content;
  final String authorId;
  final String authorName;
  final DateTime createdAt;

  const ForumReplyModel({
    required this.id,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
  });

  factory ForumReplyModel.fromJson(Map<String, dynamic> json, String id) {
    return ForumReplyModel(
      id: id,
      content: json['content'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content,
        'authorId': authorId,
        'authorName': authorName,
        'createdAt': FieldValue.serverTimestamp(),
      };
}
