// lib/shared/services/cache_service.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CacheService {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'beafrica_cache.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cached_articles (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            summary TEXT,
            url TEXT NOT NULL,
            image_url TEXT,
            source_name TEXT,
            category TEXT,
            published_at TEXT,
            cached_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE cached_weather (
            city TEXT PRIMARY KEY,
            data_json TEXT NOT NULL,
            cached_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE cached_rates (
            base_currency TEXT PRIMARY KEY,
            rates_json TEXT NOT NULL,
            cached_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE favorites (
            id TEXT PRIMARY KEY,
            type TEXT NOT NULL,
            data_json TEXT NOT NULL,
            saved_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // === MÉTÉO ===
  Future<Map<String, dynamic>?> getWeather(
    String city, {
    bool ignoreExpiry = false,
  }) async {
    final db = await database;
    final result = await db.query(
      'cached_weather',
      where: 'city = ?',
      whereArgs: [city],
    );

    if (result.isEmpty) return null;

    final row = result.first;
    final cachedAt = DateTime.parse(row['cached_at'] as String);
    final isExpired = DateTime.now().difference(cachedAt).inMinutes > 30;

    if (isExpired && !ignoreExpiry) return null;

    return jsonDecode(row['data_json'] as String);
  }

  Future<void> saveWeather(String city, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('cached_weather', {
      'city': city,
      'data_json': jsonEncode(data),
      'cached_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // === TAUX DE CHANGE ===
  Future<Map<String, dynamic>?> getRates(
    String baseCurrency, {
    bool ignoreExpiry = false,
  }) async {
    final db = await database;
    final result = await db.query(
      'cached_rates',
      where: 'base_currency = ?',
      whereArgs: [baseCurrency],
    );

    if (result.isEmpty) return null;

    final row = result.first;
    final cachedAt = DateTime.parse(row['cached_at'] as String);
    final isExpired = DateTime.now().difference(cachedAt).inHours > 6;

    if (isExpired && !ignoreExpiry) return null;

    return jsonDecode(row['rates_json'] as String);
  }

  Future<void> saveRates(String baseCurrency, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('cached_rates', {
      'base_currency': baseCurrency,
      'rates_json': jsonEncode(data),
      'cached_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // === ARTICLES ===
  Future<List<Map<String, dynamic>>> getArticles() async {
    final db = await database;
    return db.query('cached_articles', orderBy: 'published_at DESC', limit: 50);
  }

  Future<void> saveArticles(List<Map<String, dynamic>> articles) async {
    final db = await database;
    final batch = db.batch();
    for (final article in articles) {
      batch.insert('cached_articles', {
        ...article,
        'cached_at': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);

    final sevenDaysAgo = DateTime.now()
        .subtract(const Duration(days: 7))
        .toIso8601String();
    await db.delete(
      'cached_articles',
      where: 'published_at < ?',
      whereArgs: [sevenDaysAgo],
    );
  }

  Future<String?> getWeatherCacheDate(String city) async {
    final db = await database;
    final result = await db.query(
      'cached_weather',
      columns: ['cached_at'],
      where: 'city = ?',
      whereArgs: [city],
    );
    if (result.isEmpty) return null;
    final dt = DateTime.parse(result.first['cached_at'] as String);
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Future<String?> getRatesCacheDate(String baseCurrency) async {
    final db = await database;
    final result = await db.query(
      'cached_rates',
      columns: ['cached_at'],
      where: 'base_currency = ?',
      whereArgs: [baseCurrency],
    );
    if (result.isEmpty) return null;
    final dt = DateTime.parse(result.first['cached_at'] as String);
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

final cacheServiceProvider = Provider<CacheService>((ref) => CacheService());
