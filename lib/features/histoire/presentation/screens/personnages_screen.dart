// lib/features/histoire/presentation/screens/personnages_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../models/histoire_model.dart';
import '../../providers/histoire_provider.dart';
import '../widgets/personnage_card.dart';

class PersonnagesScreen extends ConsumerWidget {
  const PersonnagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personnagesAsync = ref.watch(personnagesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('Grands personnages', style: AppTypography.headlineMedium),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: personnagesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Text('Erreur de chargement', style: AppTypography.bodyMedium),
        ),
        data: (personnages) => ListView.separated(
          padding: AppSpacing.pagePadding,
          itemCount: personnages.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final personnage = personnages[index];
            return PersonnageCard(
              personnage: personnage,
              onTap: () => _showPersonnageDetail(context, personnage),
            );
          },
        ),
      ),
    );
  }

  void _showPersonnageDetail(
    BuildContext context,
    PersonnageModel personnage,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: AppSpacing.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(personnage.name, style: AppTypography.headlineLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                personnage.title,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.secondary,
                ),
              ),
              if (personnage.birthYear != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  personnage.deathYear != null
                      ? '${personnage.birthYear} - ${personnage.deathYear}'
                      : 'Ne en ${personnage.birthYear}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              const Divider(),
              const SizedBox(height: AppSpacing.lg),
              Text('Biographie', style: AppTypography.headlineMedium),
              const SizedBox(height: AppSpacing.md),
              Text(
                personnage.biography,
                style: AppTypography.bodyMedium.copyWith(height: 1.7),
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Impact historique',
                      style: AppTypography.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      personnage.impact,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
