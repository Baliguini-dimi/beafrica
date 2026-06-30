// lib/features/culture/data/culture_repository.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../models/culture_model.dart';

class CultureRepository {
  Map<String, dynamic>? _cache;

  Future<Map<String, dynamic>> _loadData() async {
    _cache ??= jsonDecode(
      await rootBundle.loadString('assets/data/culture.json'),
    );
    return _cache!;
  }

  Future<List<PlatModel>> getGastronomie() async {
    final data = await _loadData();
    final list = data['gastronomie'] as List<dynamic>? ?? [];
    return list
        .map((e) => PlatModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<InstrumentModel>> getInstruments() async {
    final data = await _loadData();
    final list = data['instruments'] as List<dynamic>? ?? [];
    return list
        .map((e) => InstrumentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<DanseModel>> getDanses() async {
    final data = await _loadData();
    final list = data['danses'] as List<dynamic>? ?? [];
    return list
        .map((e) => DanseModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ArtisanatTypeModel>> getArtisanat() async {
    final data = await _loadData();
    final list = data['artisanat'] as List<dynamic>? ?? [];
    return list
        .map((e) => ArtisanatTypeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<TenueModel>> getTenues() async {
    final data = await _loadData();
    final list = data['tenues'] as List<dynamic>? ?? [];
    return list
        .map((e) => TenueModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
