// lib/features/culture/presentation/screens/gastronomie_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../providers/culture_provider.dart';
import '../widgets/plat_card.dart';

class GastronomieScreen extends ConsumerWidget {
  const GastronomieScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platsAsync = ref.watch(gastronomieProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('Gastronomie', style: AppTypography.headlineMedium),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: platsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Text('Erreur de chargement', style: AppTypography.bodyMedium),
        ),
        data: (plats) => ListView.separated(
          padding: AppSpacing.pagePadding,
          itemCount: plats.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final plat = plats[index];
            return PlatCard(
              plat: plat,
              onTap: () => _showPlatDetail(context, plat),
            );
          },
        ),
      ),
    );
  }

  void _showPlatDetail(BuildContext context, plat) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      builder: (context) => Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text(plat.name, style: AppTypography.headlineLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${plat.type} · ${plat.region}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              plat.description,
              style: AppTypography.bodyMedium.copyWith(height: 1.6),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Ingrédients', style: AppTypography.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: (plat.ingredients as List<String>).map((i) {
                return Chip(label: Text(i, style: AppTypography.caption));
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
