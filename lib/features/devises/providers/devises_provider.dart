// lib/features/devises/providers/devises_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/services/cache_service.dart';
import '../data/currency_repository.dart';

final currencyRepositoryProvider = Provider<CurrencyRepository>((ref) {
  return CurrencyRepository(ref.watch(cacheServiceProvider));
});

class DevisesState {
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final double? result;
  final Map<String, dynamic>? rates;
  final bool isLoading;
  final String? error;
  final String? cacheDate;

  const DevisesState({
    this.fromCurrency = 'XAF',
    this.toCurrency = 'EUR',
    this.amount = 1000,
    this.result,
    this.rates,
    this.isLoading = false,
    this.error,
    this.cacheDate,
  });

  DevisesState copyWith({
    String? fromCurrency,
    String? toCurrency,
    double? amount,
    double? result,
    Map<String, dynamic>? rates,
    bool? isLoading,
    String? error,
    String? cacheDate,
  }) {
    return DevisesState(
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      amount: amount ?? this.amount,
      result: result ?? this.result,
      rates: rates ?? this.rates,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      cacheDate: cacheDate ?? this.cacheDate,
    );
  }
}

class DevisesNotifier extends StateNotifier<DevisesState> {
  final CurrencyRepository _repository;

  DevisesNotifier(this._repository) : super(const DevisesState()) {
    loadRates();
  }

  Future<void> loadRates() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _repository.getRates(state.fromCurrency);
      state = state.copyWith(rates: data, isLoading: false);
      _calculate();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Taux indisponibles — vérifiez votre connexion',
      );
    }
  }

  void _calculate() {
    if (state.rates == null) return;
    final ratesMap = state.rates!['conversion_rates'] as Map<String, dynamic>;
    final rate = (ratesMap[state.toCurrency] ?? 0).toDouble();
    state = state.copyWith(result: state.amount * rate);
  }

  void setAmount(double amount) {
    state = state.copyWith(amount: amount);
    _calculate();
  }

  void setFromCurrency(String currency) {
    state = state.copyWith(fromCurrency: currency);
    loadRates();
  }

  void setToCurrency(String currency) {
    state = state.copyWith(toCurrency: currency);
    _calculate();
  }

  void swapCurrencies() {
    final newFrom = state.toCurrency;
    final newTo = state.fromCurrency;
    state = state.copyWith(fromCurrency: newFrom, toCurrency: newTo);
    loadRates();
  }

  double getRateFor(String currency) {
    if (state.rates == null) return 0;
    final ratesMap = state.rates!['conversion_rates'] as Map<String, dynamic>;
    return (ratesMap[currency] ?? 0).toDouble();
  }
}

final devisesProvider =
    StateNotifierProvider<DevisesNotifier, DevisesState>((ref) {
  return DevisesNotifier(ref.watch(currencyRepositoryProvider));
});
