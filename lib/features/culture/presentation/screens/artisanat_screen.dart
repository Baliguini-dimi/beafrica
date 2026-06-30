// lib/features/culture/presentation/screens/artisanat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../providers/culture_provider.dart';
import '../widgets/artisan_card.dart';

class ArtisanatScreen extends ConsumerWidget {
  const ArtisanatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artisanatAsync = ref.watch(artisanatProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('Artisanat', style: AppTypography.headlineMedium),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: artisanatAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Text('Erreur de chargement', style: AppTypography.bodyMedium),
        ),
        data: (artisanats) => GridView.builder(
          padding: AppSpacing.pagePadding,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.85,
          ),
          itemCount: artisanats.length,
          itemBuilder: (context, index) {
            return ArtisanatCard(artisanat: artisanats[index]);
          },
        ),
      ),
    );
  }
}
