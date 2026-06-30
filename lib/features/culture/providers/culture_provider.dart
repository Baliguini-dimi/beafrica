// lib/features/culture/providers/culture_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/culture_model.dart';
import '../data/culture_repository.dart';

final cultureRepositoryProvider = Provider<CultureRepository>((ref) {
  return CultureRepository();
});

final gastronomieProvider = FutureProvider<List<PlatModel>>((ref) {
  return ref.watch(cultureRepositoryProvider).getGastronomie();
});

final instrumentsProvider = FutureProvider<List<InstrumentModel>>((ref) {
  return ref.watch(cultureRepositoryProvider).getInstruments();
});

final dansesProvider = FutureProvider<List<DanseModel>>((ref) {
  return ref.watch(cultureRepositoryProvider).getDanses();
});

final artisanatProvider = FutureProvider<List<ArtisanatTypeModel>>((ref) {
  return ref.watch(cultureRepositoryProvider).getArtisanat();
});

final tenuesProvider = FutureProvider<List<TenueModel>>((ref) {
  return ref.watch(cultureRepositoryProvider).getTenues();
});
