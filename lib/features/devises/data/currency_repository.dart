// lib/features/devises/data/currency_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../shared/services/cache_service.dart';

class CurrencyRepository {
  final Dio _dio = Dio();
  final CacheService _cache;

  CurrencyRepository(this._cache);

  Future<Map<String, dynamic>> getRates(String baseCurrency) async {
    // 1. Cache valide 6 heures
    final cached = await _cache.getRates(baseCurrency);
    if (cached != null) return cached;

    // 2. Appel API
    try {
      final key = dotenv.env['EXCHANGERATE_API_KEY'];
      final response = await _dio.get(
        'https://v6.exchangerate-api.com/v6/$key/latest/$baseCurrency',
      );

      final data = response.data as Map<String, dynamic>;
      await _cache.saveRates(baseCurrency, data);
      return data;
    } on DioException {
      // 3. Retourner cache expiré (offline)
      final stale = await _cache.getRates(baseCurrency, ignoreExpiry: true);
      if (stale != null) return stale;
      throw Exception('Taux de change indisponibles');
    }
  }
}
