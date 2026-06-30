// lib/features/devises/presentation/widgets/currency_selector.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../data/currencies.dart';

class CurrencySelector extends StatelessWidget {
  final String selectedCurrency;
  final ValueChanged<String> onChanged;

  const CurrencySelector({
    super.key,
    required this.selectedCurrency,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedCurrency,
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(
              Icons.arrow_drop_down,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Choisir une devise', style: AppTypography.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: beafricaCurrencies.entries.map((entry) {
                final isSelected = entry.key == selectedCurrency;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      entry.key.substring(0, 2),
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  title: Text(entry.key, style: AppTypography.headlineSmall),
                  subtitle: Text(
                    entry.value['name']!,
                    style: AppTypography.bodySmall,
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    onChanged(entry.key);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
