// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
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

              const SizedBox(height: AppSpacing.xl),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
