// lib/features/meteo/providers/weather_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/services/cache_service.dart';
import '../data/weather_cities.dart';
import '../data/weather_repository.dart';
import '../../../models/weather_model.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepository(ref.watch(cacheServiceProvider));
});

class WeatherState {
  final WeatherModel? weather;
  final List<Map<String, dynamic>> forecast;
  final bool isLoading;
  final String? error;
  final String selectedCity;
  final String? cacheDate;

  const WeatherState({
    this.weather,
    this.forecast = const [],
    this.isLoading = false,
    this.error,
    this.selectedCity = 'Bangui',
    this.cacheDate,
  });

  WeatherState copyWith({
    WeatherModel? weather,
    List<Map<String, dynamic>>? forecast,
    bool? isLoading,
    String? error,
    String? selectedCity,
    String? cacheDate,
  }) {
    return WeatherState(
      weather: weather ?? this.weather,
      forecast: forecast ?? this.forecast,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedCity: selectedCity ?? this.selectedCity,
      cacheDate: cacheDate ?? this.cacheDate,
    );
  }
}

class WeatherNotifier extends StateNotifier<WeatherState> {
  final WeatherRepository _repository;

  WeatherNotifier(this._repository) : super(const WeatherState()) {
    loadWeather('Bangui');
  }

  Future<void> loadWeather(String city) async {
    final coords = rcaCities[city];
    if (coords == null) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
      selectedCity: city,
    );

    try {
      final weather = await _repository.getWeather(
        city,
        coords['lat']!,
        coords['lon']!,
      );
      final forecast = await _repository.getForecast(
        coords['lat']!,
        coords['lon']!,
      );
      state = state.copyWith(
        weather: weather,
        forecast: forecast,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Météo indisponible — vérifiez votre connexion',
      );
    }
  }

  void changeCity(String city) {
    loadWeather(city);
  }
}

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  return WeatherNotifier(ref.watch(weatherRepositoryProvider));
});
