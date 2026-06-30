// lib/features/histoire/providers/histoire_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/histoire_model.dart';
import '../data/histoire_repository.dart';

final histoireRepositoryProvider = Provider<HistoireRepository>((ref) {
  return HistoireRepository();
});

// Providers individuels pour chaque section
final chronologieProvider = FutureProvider<List<HistoireEventModel>>((ref) {
  return ref.watch(histoireRepositoryProvider).getChronologie();
});

final personnagesProvider = FutureProvider<List<PersonnageModel>>((ref) {
  return ref.watch(histoireRepositoryProvider).getPersonnages();
});

final royaumesProvider = FutureProvider<List<RoyaumeModel>>((ref) {
  return ref.watch(histoireRepositoryProvider).getRoyaumes();
});

final contesProvider = FutureProvider<List<ConteModel>>((ref) {
  return ref.watch(histoireRepositoryProvider).getContes();
});

final proverbesProvider = FutureProvider<List<ProverbeModel>>((ref) {
  return ref.watch(histoireRepositoryProvider).getProverbes();
});
