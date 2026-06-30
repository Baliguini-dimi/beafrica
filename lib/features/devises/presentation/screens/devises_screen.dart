// lib/features/devises/presentation/screens/devises_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../data/currencies.dart';
import '../../providers/devises_provider.dart';
import '../widgets/currency_selector.dart';

class DevisesScreen extends ConsumerStatefulWidget {
  const DevisesScreen({super.key});

  @override
  ConsumerState<DevisesScreen> createState() => _DevisesScreenState();
}

class _DevisesScreenState extends ConsumerState<DevisesScreen> {
  final _amountController = TextEditingController(text: '1000');

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String _formatNumber(double value) {
    return value.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    final devisesState = ref.watch(devisesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title:
            Text('Convertisseur Devises', style: AppTypography.headlineMedium),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () => ref.read(devisesProvider.notifier).loadRates(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),

            // === CONVERTISSEUR PRINCIPAL ===
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  // Montant source
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: AppTypography.headlineLarge,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '0',
                          ),
                          onChanged: (value) {
                            final amount = double.tryParse(value) ?? 0;
                            ref
                                .read(devisesProvider.notifier)
                                .setAmount(amount);
                          },
                        ),
                      ),
                      CurrencySelector(
                        selectedCurrency: devisesState.fromCurrency,
                        onChanged: (currency) {
                          ref
                              .read(devisesProvider.notifier)
                              .setFromCurrency(currency);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Bouton swap
                  Center(
                    child: GestureDetector(
                      onTap: () =>
                          ref.read(devisesProvider.notifier).swapCurrencies(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.swap_vert,
                          color: AppColors.textOnPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Résultat
                  Row(
                    children: [
                      Expanded(
                        child: devisesState.isLoading
                            ? const SizedBox(
                                height: 32,
                                child: Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                devisesState.result != null
                                    ? _formatNumber(devisesState.result!)
                                    : '--',
                                style: AppTypography.headlineLarge.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                      ),
                      CurrencySelector(
                        selectedCurrency: devisesState.toCurrency,
                        onChanged: (currency) {
                          ref
                              .read(devisesProvider.notifier)
                              .setToCurrency(currency);
                        },
                      ),
                    ],
                  ),

                  if (devisesState.error != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      devisesState.error!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // === VUE MULTI-DEVISES ===
            Text(
              '1 000 FCFA en devises',
              style: AppTypography.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.md),

            if (devisesState.rates != null)
              ...beafricaCurrencies.keys
                  .where((c) => c != 'XAF')
                  .take(5)
                  .map((currency) {
                final rate =
                    ref.read(devisesProvider.notifier).getRateFor(currency);
                final value = 1000 * rate;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currency,
                              style: AppTypography.headlineSmall,
                            ),
                            Text(
                              beafricaCurrencies[currency]!['name']!,
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                        Text(
                          _formatNumber(value),
                          style: AppTypography.headlineSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

            const SizedBox(height: AppSpacing.lg),

            Center(
              child: Text(
                'Taux mis à jour automatiquement toutes les 6 heures',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
