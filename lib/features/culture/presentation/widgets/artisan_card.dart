// lib/features/culture/presentation/widgets/artisan_card.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../models/culture_model.dart';

class ArtisanatCard extends StatelessWidget {
  final ArtisanatTypeModel artisanat;

  const ArtisanatCard({super.key, required this.artisanat});

  IconData _getIcon(String name) {
    final n = name.toLowerCase();
    if (n.contains('poterie')) return Icons.local_fire_department_outlined;
    if (n.contains('vannerie')) return Icons.grid_view_outlined;
    if (n.contains('sculpture')) return Icons.brush_outlined;
    if (n.contains('bijoux')) return Icons.diamond_outlined;
    if (n.contains('tissage')) return Icons.texture_outlined;
    return Icons.palette_outlined;
  }

  @override
  Widget build(BuildContext context) {
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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(
              _getIcon(artisanat.name),
              color: AppColors.accent,
              size: 22,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(artisanat.name, style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            artisanat.description,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
