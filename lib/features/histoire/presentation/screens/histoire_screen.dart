// lib/features/histoire/presentation/screens/histoire_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';

class HistoireScreen extends ConsumerWidget {
  const HistoireScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title:
            Text('Histoire & Patrimoine', style: AppTypography.headlineMedium),
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

            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.account_balance_outlined,
                    color: AppColors.textOnPrimary,
                    size: 36,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Histoire & Patrimoine',
                    style: AppTypography.headlineLarge.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Découvrez l\'histoire millénaire de la République Centrafricaine',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Text(
              'EXPLORER',
              style: AppTypography.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Sections
            _SectionTile(
              icon: Icons.timeline_outlined,
              title: 'Chronologie historique',
              subtitle: 'De la préhistoire à aujourd\'hui',
              color: AppColors.primary,
              onTap: () => context.push(AppRouter.chronologie),
            ),
            const SizedBox(height: AppSpacing.md),
            _SectionTile(
              icon: Icons.person_outlined,
              title: 'Grands personnages',
              subtitle: 'Figures marquantes de la RCA',
              color: AppColors.secondary,
              onTap: () => context.push(AppRouter.personnages),
            ),
            const SizedBox(height: AppSpacing.md),
            _SectionTile(
              icon: Icons.castle_outlined,
              title: 'Royaumes & Empires',
              subtitle: 'Les grandes puissances précoloniales',
              color: AppColors.accent,
              onTap: () => context.push(AppRouter.royaumes),
            ),
            const SizedBox(height: AppSpacing.md),
            _SectionTile(
              icon: Icons.auto_stories_outlined,
              title: 'Contes & Mythes',
              subtitle: 'La tradition orale centrafricaine',
              color: AppColors.warning,
              onTap: () => context.push(AppRouter.contes),
            ),
            const SizedBox(height: AppSpacing.md),
            _SectionTile(
              icon: Icons.format_quote_outlined,
              title: 'Proverbes Sango',
              subtitle: 'La sagesse ancestrale en mots',
              color: AppColors.success,
              onTap: () => context.push(AppRouter.proverbes),
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
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
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
    );
  }
}
