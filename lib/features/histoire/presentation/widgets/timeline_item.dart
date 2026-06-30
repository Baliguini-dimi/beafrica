// lib/features/histoire/presentation/widgets/timeline_item.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../models/histoire_model.dart';

class TimelineItem extends StatelessWidget {
  final HistoireEventModel event;
  final bool isLast;

  const TimelineItem({
    super.key,
    required this.event,
    this.isLast = false,
  });

  Color _eraColor(String era) {
    switch (era) {
      case 'precolonial':
        return AppColors.secondary;
      case 'colonial':
        return AppColors.error;
      case 'independance':
        return AppColors.primary;
      case 'moderne':
        return AppColors.accent;
      default:
        return AppColors.textHint;
    }
  }

  String _eraLabel(String era) {
    switch (era) {
      case 'precolonial':
        return 'Précolonial';
      case 'colonial':
        return 'Colonial';
      case 'independance':
        return 'Indépendance';
      case 'moderne':
        return 'Moderne';
      default:
        return era;
    }
  }

  String _formatYear(int year) {
    if (year < 0) return '${year.abs()} av. J.-C.';
    return year.toString();
  }

  @override
  Widget build(BuildContext context) {
    final color = _eraColor(event.era);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ligne temporelle
          SizedBox(
            width: 60,
            child: Column(
              children: [
                Text(
                  _formatYear(event.year),
                  style: AppTypography.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.surface,
                      width: 2,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.border,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // Contenu
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : AppSpacing.lg,
              ),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge ère
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        _eraLabel(event.era),
                        style: AppTypography.caption.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    Text(event.title, style: AppTypography.headlineSmall),

                    const SizedBox(height: AppSpacing.sm),

                    Text(
                      event.description,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),

                    if (event.personnages.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.xs,
                        children: event.personnages.map((p) {
                          return Chip(
                            label: Text(
                              p,
                              style: AppTypography.caption,
                            ),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
