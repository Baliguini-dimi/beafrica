// lib/shared/widgets/locked_menu_tile.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

class LockedMenuTile extends StatelessWidget {
  final String moduleName;
  final String moduleDescription;
  final IconData icon;
  final String version; // "v2" ou "v3"

  const LockedMenuTile({
    super.key,
    required this.moduleName,
    required this.moduleDescription,
    required this.icon,
    this.version = 'v2',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(
        '/coming-soon',
        extra: {
          'moduleName': moduleName,
          'moduleDescription': moduleDescription,
          'icon': icon,
        },
      ),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.lockedBg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(icon, color: AppColors.locked, size: 22),
                ),
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(
                      version,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    moduleName,
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    moduleDescription,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textHint,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.lockedBg,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                'Bientôt',
                style: AppTypography.caption.copyWith(color: AppColors.locked),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
