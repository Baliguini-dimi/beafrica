// lib/features/astuces/presentation/widgets/astuce_card.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../models/astuce_model.dart';
import '../../data/astuces_repository.dart';

class AstuceCard extends StatelessWidget {
  final AstuceModel astuce;
  final String iconName;
  final VoidCallback onTap;

  const AstuceCard({
    super.key,
    required this.astuce,
    required this.iconName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final repo = AstucesRepository();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(
                repo.getIconData(iconName),
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(astuce.title, style: AppTypography.headlineSmall),
                  const SizedBox(height: 4),
                  Text(
                    'Mis à jour le ${astuce.updatedAt}',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
