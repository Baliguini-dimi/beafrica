// lib/features/culture/presentation/screens/culture_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';

class CultureScreen extends StatelessWidget {
  const CultureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('Culture & Artisanat', style: AppTypography.headlineMedium),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
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
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.palette_outlined,
                    color: AppColors.textOnPrimary,
                    size: 36,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Culture & Artisanat',
                    style: AppTypography.headlineLarge.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'La richesse culturelle vivante de la République Centrafricaine',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'EXPLORER',
              style: AppTypography.caption.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _SectionTile(
              icon: Icons.restaurant_outlined,
              title: 'Gastronomie',
              subtitle: 'Plats traditionnels et recettes',
              color: AppColors.error,
              onTap: () => context.push(AppRouter.gastronomie),
            ),
            const SizedBox(height: AppSpacing.md),
            _SectionTile(
              icon: Icons.music_note_outlined,
              title: 'Musique & Instruments',
              subtitle: 'Sons et rythmes centrafricains',
              color: AppColors.accent,
              onTap: () => context.push(AppRouter.musique),
            ),
            const SizedBox(height: AppSpacing.md),
            _SectionTile(
              icon: Icons.diamond_outlined,
              title: 'Artisanat',
              subtitle: 'Savoir-faire ancestral',
              color: AppColors.secondary,
              onTap: () => context.push(AppRouter.artisanat),
            ),
            const SizedBox(height: AppSpacing.md),
            _SectionTile(
              icon: Icons.checkroom_outlined,
              title: 'Tenues traditionnelles',
              subtitle: 'Habillements par peuple et occasion',
              color: AppColors.primary,
              onTap: () => context.push(AppRouter.tenues),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _SectionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.headlineSmall),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
