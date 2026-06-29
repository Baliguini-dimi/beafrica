// lib/shared/services/connectivity_service.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<bool>((ref) {
  return Connectivity().onConnectivityChanged.map(
        (result) => result != ConnectivityResult.none,
      );
});

// Provider synchrone pour lecture ponctuelle
final isOnlineProvider = FutureProvider<bool>((ref) async {
  final result = await Connectivity().checkConnectivity();
  return result != ConnectivityResult.none;
});
