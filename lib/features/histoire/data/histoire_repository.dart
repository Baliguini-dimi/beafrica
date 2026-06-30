// lib/features/histoire/data/histoire_repository.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../models/histoire_model.dart';

class HistoireRepository {
  Map<String, dynamic>? _cache;

  Future<Map<String, dynamic>> _loadData() async {
    _cache ??= jsonDecode(
      await rootBundle.loadString('assets/data/histoire.json'),
    );
    return _cache!;
  }

  Future<List<HistoireEventModel>> getChronologie() async {
    final data = await _loadData();
    final list = data['chronologie'] as List<dynamic>? ?? [];
    return list
        .map((e) => HistoireEventModel.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.year.compareTo(b.year));
  }

  Future<List<PersonnageModel>> getPersonnages() async {
    final data = await _loadData();
    final list = data['personnages'] as List<dynamic>? ?? [];
    return list
        .map((e) => PersonnageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<RoyaumeModel>> getRoyaumes() async {
    final data = await _loadData();
    final list = data['royaumes'] as List<dynamic>? ?? [];
    return list
        .map((e) => RoyaumeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ConteModel>> getContes() async {
    final data = await _loadData();
    final list = data['contes'] as List<dynamic>? ?? [];
    return list
        .map((e) => ConteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProverbeModel>> getProverbes() async {
    final data = await _loadData();
    final list = data['proverbes'] as List<dynamic>? ?? [];
    return list
        .map((e) => ProverbeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
