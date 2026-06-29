// lib/features/home/presentation/widgets/exchange_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../home/providers/home_provider.dart';

class ExchangeWidget extends ConsumerWidget {
  const ExchangeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.currency_exchange,
                size: 16,
                color: AppColors.secondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Taux de change — 1 000 FCFA',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          homeState.isLoadingRates
              ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : homeState.ratesError != null || homeState.rates == null
              ? Text(
                  'Taux indisponibles',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: _RateItem(
                        currency: 'EUR',
                        flag: '🇪🇺',
                        value: homeState.rates!['EUR'] != null
                            ? (1000 * homeState.rates!['EUR']!).toStringAsFixed(
                                2,
                              )
                            : '--',
                      ),
                    ),
                    Container(width: 1, height: 32, color: AppColors.divider),
                    Expanded(
                      child: _RateItem(
                        currency: 'USD',
                        flag: '🇺🇸',
                        value: homeState.rates!['USD'] != null
                            ? (1000 * homeState.rates!['USD']!).toStringAsFixed(
                                2,
                              )
                            : '--',
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _RateItem extends StatelessWidget {
  final String currency;
  final String flag;
  final String value;

  const _RateItem({
    required this.currency,
    required this.flag,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$flag $currency', style: AppTypography.labelMedium),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
