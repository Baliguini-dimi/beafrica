// lib/features/home/providers/home_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/services/cache_service.dart';
import '../data/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(ref.watch(cacheServiceProvider));
});

// État de l'accueil
class HomeState {
  final Map<String, dynamic>? weather;
  final Map<String, double>? rates;
  final bool isLoadingWeather;
  final bool isLoadingRates;
  final String? weatherError;
  final String? ratesError;
  final String? weatherCacheDate;
  final String? ratesCacheDate;

  const HomeState({
    this.weather,
    this.rates,
    this.isLoadingWeather = false,
    this.isLoadingRates = false,
    this.weatherError,
    this.ratesError,
    this.weatherCacheDate,
    this.ratesCacheDate,
  });

  HomeState copyWith({
    Map<String, dynamic>? weather,
    Map<String, double>? rates,
    bool? isLoadingWeather,
    bool? isLoadingRates,
    String? weatherError,
    String? ratesError,
    String? weatherCacheDate,
    String? ratesCacheDate,
  }) {
    return HomeState(
      weather: weather ?? this.weather,
      rates: rates ?? this.rates,
      isLoadingWeather: isLoadingWeather ?? this.isLoadingWeather,
      isLoadingRates: isLoadingRates ?? this.isLoadingRates,
      weatherError: weatherError,
      ratesError: ratesError,
      weatherCacheDate: weatherCacheDate ?? this.weatherCacheDate,
      ratesCacheDate: ratesCacheDate ?? this.ratesCacheDate,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final HomeRepository _repository;

  HomeNotifier(this._repository) : super(const HomeState()) {
    loadAll();
  }

  Future<void> loadAll() async {
    await Future.wait([loadWeather(), loadRates()]);
  }

  Future<void> loadWeather() async {
    state = state.copyWith(isLoadingWeather: true, weatherError: null);
    try {
      final weather = await _repository.getWeatherBangui();
      state = state.copyWith(weather: weather, isLoadingWeather: false);
    } catch (e) {
      state = state.copyWith(
        isLoadingWeather: false,
        weatherError: 'Météo indisponible',
      );
    }
  }

  Future<void> loadRates() async {
    state = state.copyWith(isLoadingRates: true, ratesError: null);
    try {
      final rates = await _repository.getExchangeRates();
      state = state.copyWith(rates: rates, isLoadingRates: false);
    } catch (e) {
      state = state.copyWith(
        isLoadingRates: false,
        ratesError: 'Taux indisponibles',
      );
    }
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(ref.watch(homeRepositoryProvider));
});
