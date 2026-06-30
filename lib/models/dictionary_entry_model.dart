// lib/models/dictionary_entry_model.dart

class DictionaryEntryModel {
  final String id;
  final String french;
  final String sango;
  final String phonetic;
  final String category;
  final String? example;

  const DictionaryEntryModel({
    required this.id,
    required this.french,
    required this.sango,
    required this.phonetic,
    required this.category,
    this.example,
  });

  factory DictionaryEntryModel.fromJson(Map<String, dynamic> json) {
    return DictionaryEntryModel(
      id: json['id'] ?? '',
      french: json['french'] ?? '',
      sango: json['sango'] ?? '',
      phonetic: json['phonetic'] ?? '',
      category: json['category'] ?? '',
      example: json['example'],
    );
  }
}

class DictionaryCategoryModel {
  final String id;
  final String label;
  final List<DictionaryEntryModel> entries;

  const DictionaryCategoryModel({
    required this.id,
    required this.label,
    required this.entries,
  });

  factory DictionaryCategoryModel.fromJson(Map<String, dynamic> json) {
    return DictionaryCategoryModel(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      entries: (json['entries'] as List<dynamic>? ?? [])
          .map((e) => DictionaryEntryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
