// lib/features/meteo/data/weather_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../shared/services/cache_service.dart';
import '../../../models/weather_model.dart';

class WeatherRepository {
  final Dio _dio = Dio();
  final CacheService _cache;

  WeatherRepository(this._cache);

  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<WeatherModel> getWeather(
    String city,
    double lat,
    double lon,
  ) async {
    // 1. Vérifier cache (30 min)
    final cached = await _cache.getWeather(city);
    if (cached != null) {
      return WeatherModel.fromOpenWeatherJson(cached);
    }

    // 2. Appel API
    try {
      final response = await _dio.get(
        '$_baseUrl/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': dotenv.env['OPENWEATHER_API_KEY'],
          'units': 'metric',
          'lang': 'fr',
        },
      );
      final data = response.data as Map<String, dynamic>;
      await _cache.saveWeather(city, data);
      return WeatherModel.fromOpenWeatherJson(data);
    } on DioException {
      // 3. Retourner cache expiré si disponible
      final stale = await _cache.getWeather(city, ignoreExpiry: true);
      if (stale != null) return WeatherModel.fromOpenWeatherJson(stale);
      throw Exception('Météo indisponible pour $city');
    }
  }

  Future<List<Map<String, dynamic>>> getForecast(
    double lat,
    double lon,
  ) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/forecast',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': dotenv.env['OPENWEATHER_API_KEY'],
          'units': 'metric',
          'lang': 'fr',
          'cnt': 9, // 3 jours × 3 créneaux
        },
      );
      final data = response.data as Map<String, dynamic>;
      final list = data['list'] as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }
}
