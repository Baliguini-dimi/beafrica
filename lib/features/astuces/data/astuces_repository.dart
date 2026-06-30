// lib/features/astuces/data/astuces_repository.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../models/astuce_model.dart';

class AstucesRepository {
  List<AstuceCategoryModel>? _cache;

  Future<List<AstuceCategoryModel>> getCategories() async {
    if (_cache != null) return _cache!;

    final jsonStr = await rootBundle.loadString('assets/data/astuces.json');
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    final list = data['categories'] as List<dynamic>? ?? [];

    _cache = list
        .map((e) => AstuceCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return _cache!;
  }

  Future<List<AstuceModel>> getAllArticles() async {
    final categories = await getCategories();
    return categories.expand((c) => c.articles).toList();
  }

  IconData getIconData(String iconName) {
    switch (iconName) {
      case 'flight':
        return Icons.flight_outlined;
      case 'health_and_safety':
        return Icons.health_and_safety_outlined;
      case 'currency_exchange':
        return Icons.currency_exchange;
      case 'home':
        return Icons.home_outlined;
      case 'description':
        return Icons.description_outlined;
      case 'business':
        return Icons.business_center_outlined;
      default:
        return Icons.lightbulb_outlined;
    }
  }
}
