// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Import ajouté
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart'; // Import ajouté
import '../widgets/weather_widget.dart';
import '../widgets/exchange_widget.dart';
import '../widgets/news_preview_widget.dart';
import '../widgets/quick_access_grid.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          // Sera branché sur le provider au Sprint 3 complet
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),

              // === SALUTATION ===
              Text('Balao ! ', style: AppTypography.headlineLarge),
              Text(
                'Découvrez la République Centrafricaine',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // === MÉTÉO ===
              const WeatherWidget(),

              const SizedBox(height: AppSpacing.md),

              // === TAUX DE CHANGE ===
              const ExchangeWidget(),

              const SizedBox(height: AppSpacing.xl),

              // === ACTUALITÉS ===
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Actualités', style: AppTypography.headlineMedium),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const NewsPreviewWidget(),

              const SizedBox(height: AppSpacing.xl),

              // === ACCÈS RAPIDE ===
              Text('Accès rapide', style: AppTypography.headlineMedium),
              const SizedBox(height: AppSpacing.md),
              const QuickAccessGrid(),

              // === NOUVELLE CARTE "DÉCOUVRIR PLUS" ===
              const SizedBox(height: AppSpacing.xl),
              InkWell(
                onTap: () => context.push(AppRouter.discoverMore),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome_outlined,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          'Découvrir ce qui arrive bientôt',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
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
