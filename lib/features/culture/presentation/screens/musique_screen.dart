// lib/features/culture/presentation/screens/musique_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../providers/culture_provider.dart';

class MusiqueScreen extends ConsumerWidget {
  const MusiqueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instrumentsAsync = ref.watch(instrumentsProvider);
    final dansesAsync = ref.watch(dansesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('Musique & Danses', style: AppTypography.headlineMedium),
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
            Text('Instruments traditionnels',
                style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.md),
            instrumentsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Erreur', style: AppTypography.bodySmall),
              data: (instruments) => Column(
                children: instruments.map((instr) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.music_note,
                                  color: AppColors.accent, size: 20),
                              const SizedBox(width: AppSpacing.sm),
                              Text(instr.name,
                                  style: AppTypography.headlineSmall),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            instr.description,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Peuples : ${instr.peoples.join(', ')}',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Danses traditionnelles', style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.md),
            dansesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Erreur', style: AppTypography.bodySmall),
              data: (danses) => Column(
                children: danses.map((danse) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(danse.name, style: AppTypography.headlineSmall),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            danse.description,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '${danse.origin} · ${danse.occasion}',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
