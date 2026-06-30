// lib/features/dictionnaire/data/dictionnaire_repository.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../models/dictionary_entry_model.dart';

class DictionnaireRepository {
  List<DictionaryCategoryModel>? _cache;

  Future<List<DictionaryCategoryModel>> getCategories() async {
    if (_cache != null) return _cache!;

    final jsonStr =
        await rootBundle.loadString('assets/data/sango_dictionary.json');
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    final list = data['categories'] as List<dynamic>? ?? [];

    _cache = list
        .map((e) => DictionaryCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return _cache!;
  }

  Future<List<DictionaryEntryModel>> getAllEntries() async {
    final categories = await getCategories();
    return categories.expand((c) => c.entries).toList();
  }
}
