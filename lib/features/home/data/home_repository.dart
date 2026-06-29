// lib/features/home/data/home_repository.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../shared/services/cache_service.dart';

class HomeRepository {
  final Dio _dio = Dio();
  final CacheService _cache;

  HomeRepository(this._cache);

  // === MÉTÉO BANGUI ===
  Future<Map<String, dynamic>> getWeatherBangui() async {
    const city = 'Bangui';
    const lat = 4.3612;
    const lon = 18.5550;

    // 1. Vérifier cache (30 min)
    final cached = await _cache.getWeather(city);
    if (cached != null) return cached;

    // 2. Appel API
    try {
      final response = await _dio.get(
        'https://api.openweathermap.org/data/2.5/weather',
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
      return data;
    } catch (e) {
      // 3. Retourner cache expiré si disponible
      final stale = await _cache.getWeather(city, ignoreExpiry: true);
      if (stale != null) return stale;
      throw Exception('Météo indisponible');
    }
  }

  // === TAUX DE CHANGE ===
  Future<Map<String, double>> getExchangeRates() async {
    const base = 'XAF';

    // 1. Vérifier cache (6h)
    final cached = await _cache.getRates(base);
    if (cached != null) {
      final rates = cached['conversion_rates'] as Map<String, dynamic>;
      return {
        'EUR': (rates['EUR'] ?? 0).toDouble(),
        'USD': (rates['USD'] ?? 0).toDouble(),
      };
    }

    // 2. Appel API
    try {
      final key = dotenv.env['EXCHANGERATE_API_KEY'];
      final response = await _dio.get(
        'https://v6.exchangerate-api.com/v6/$key/latest/$base',
      );
      final data = response.data as Map<String, dynamic>;
      await _cache.saveRates(base, data);
      final rates = data['conversion_rates'] as Map<String, dynamic>;
      return {
        'EUR': (rates['EUR'] ?? 0).toDouble(),
        'USD': (rates['USD'] ?? 0).toDouble(),
      };
    } catch (e) {
      // 3. Retourner cache expiré
      final stale = await _cache.getRates(base, ignoreExpiry: true);
      if (stale != null) {
        final rates = stale['conversion_rates'] as Map<String, dynamic>;
        return {
          'EUR': (rates['EUR'] ?? 0).toDouble(),
          'USD': (rates['USD'] ?? 0).toDouble(),
        };
      }
      throw Exception('Taux indisponibles');
    }
  }
}
