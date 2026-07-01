// lib/features/communaute/presentation/screens/communaute_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../data/communaute_repository.dart';

class CommunauteScreen extends StatelessWidget {
  const CommunauteScreen({super.key});

  static const Map<String, IconData> _icons = {
    'public': Icons.public_outlined,
    'flight_land': Icons.flight_land_outlined,
    'work': Icons.work_outline,
    'language': Icons.language_outlined,
    'volunteer_activism': Icons.volunteer_activism_outlined,
    'forum': Icons.forum_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: AppSpacing.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.people_outlined,
                    color: AppColors.textOnPrimary,
                    size: 36,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Communauté Diaspora',
                    style: AppTypography.headlineLarge.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Échangez avec la communauté centrafricaine du monde entier',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'THÈMES DE DISCUSSION',
              style: AppTypography.caption.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...CommunauteRepository.themes.map((theme) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: InkWell(
                  onTap: () => context.push(
                    '${AppRouter.communauteTheme}/${theme['id']}',
                    extra: theme['label'],
                  ),
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
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Icon(
                            _icons[theme['icon']] ?? Icons.forum_outlined,
                            color: AppColors.accent,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: Text(
                            theme['label']!,
                            style: AppTypography.headlineSmall,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppColors.textHint,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
