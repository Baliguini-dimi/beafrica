// lib/models/histoire_model.dart

class HistoireEventModel {
  final String id;
  final String title;
  final String description;
  final int year;
  final String? imageUrl;
  final List<String> personnages;
  final String era;

  const HistoireEventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.year,
    this.imageUrl,
    this.personnages = const [],
    required this.era,
  });

  factory HistoireEventModel.fromJson(Map<String, dynamic> json) {
    return HistoireEventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      year: json['year'] ?? 0,
      imageUrl: json['image_url'],
      personnages: List<String>.from(json['personnages'] ?? []),
      era: json['era'] ?? 'moderne',
    );
  }
}

class PersonnageModel {
  final String id;
  final String name;
  final String title;
  final String biography;
  final String? imageUrl;
  final String? birthYear;
  final String? deathYear;
  final String impact;
  final String category;

  const PersonnageModel({
    required this.id,
    required this.name,
    required this.title,
    required this.biography,
    this.imageUrl,
    this.birthYear,
    this.deathYear,
    required this.impact,
    required this.category,
  });

  factory PersonnageModel.fromJson(Map<String, dynamic> json) {
    return PersonnageModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      biography: json['biography'] ?? '',
      imageUrl: json['image_url'],
      birthYear: json['birth_year'],
      deathYear: json['death_year'],
      impact: json['impact'] ?? '',
      category: json['category'] ?? 'politique',
    );
  }
}

class RoyaumeModel {
  final String id;
  final String name;
  final String period;
  final String description;
  final String territoire;
  final List<String> keyFigures;

  const RoyaumeModel({
    required this.id,
    required this.name,
    required this.period,
    required this.description,
    required this.territoire,
    this.keyFigures = const [],
  });

  factory RoyaumeModel.fromJson(Map<String, dynamic> json) {
    return RoyaumeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      period: json['period'] ?? '',
      description: json['description'] ?? '',
      territoire: json['territoire'] ?? '',
      keyFigures: List<String>.from(json['key_figures'] ?? []),
    );
  }
}

class ConteModel {
  final String id;
  final String title;
  final String content;
  final String origin;
  final String type;
  final String? moral;
  final String? imageUrl;

  const ConteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.origin,
    required this.type,
    this.moral,
    this.imageUrl,
  });

  factory ConteModel.fromJson(Map<String, dynamic> json) {
    return ConteModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      origin: json['origin'] ?? '',
      type: json['type'] ?? 'conte',
      moral: json['moral'],
      imageUrl: json['image_url'],
    );
  }
}

class ProverbeModel {
  final String id;
  final String sango;
  final String french;
  final String explication;
  final String? context;

  const ProverbeModel({
    required this.id,
    required this.sango,
    required this.french,
    required this.explication,
    this.context,
  });

  factory ProverbeModel.fromJson(Map<String, dynamic> json) {
    return ProverbeModel(
      id: json['id'] ?? '',
      sango: json['sango'] ?? '',
      french: json['french'] ?? '',
      explication: json['explication'] ?? '',
      context: json['context'],
    );
  }
}
