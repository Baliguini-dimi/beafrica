// lib/models/culture_model.dart

class PlatModel {
  final String id;
  final String name;
  final String description;
  final List<String> ingredients;
  final String region;
  final String type;
  final String? imageUrl;

  const PlatModel({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.region,
    required this.type,
    this.imageUrl,
  });

  factory PlatModel.fromJson(Map<String, dynamic> json) {
    return PlatModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      region: json['region'] ?? '',
      type: json['type'] ?? '',
      imageUrl: json['image_url'],
    );
  }
}

class InstrumentModel {
  final String id;
  final String name;
  final String description;
  final List<String> peoples;
  final String occasions;

  const InstrumentModel({
    required this.id,
    required this.name,
    required this.description,
    required this.peoples,
    required this.occasions,
  });

  factory InstrumentModel.fromJson(Map<String, dynamic> json) {
    return InstrumentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      peoples: List<String>.from(json['peoples'] ?? []),
      occasions: json['occasions'] ?? '',
    );
  }
}

class DanseModel {
  final String id;
  final String name;
  final String description;
  final String occasion;
  final String origin;

  const DanseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.occasion,
    required this.origin,
  });

  factory DanseModel.fromJson(Map<String, dynamic> json) {
    return DanseModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      occasion: json['occasion'] ?? '',
      origin: json['origin'] ?? '',
    );
  }
}

class ArtisanatTypeModel {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;

  const ArtisanatTypeModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
  });

  factory ArtisanatTypeModel.fromJson(Map<String, dynamic> json) {
    return ArtisanatTypeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
    );
  }
}

class TenueModel {
  final String id;
  final String peuple;
  final String occasion;
  final String description;

  const TenueModel({
    required this.id,
    required this.peuple,
    required this.occasion,
    required this.description,
  });

  factory TenueModel.fromJson(Map<String, dynamic> json) {
    return TenueModel(
      id: json['id'] ?? '',
      peuple: json['peuple'] ?? '',
      occasion: json['occasion'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
