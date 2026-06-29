// lib/features/radio/presentation/screens/radio_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../providers/radio_provider.dart';

class RadioScreen extends ConsumerWidget {
  const RadioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radioState = ref.watch(radioProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('Radio', style: AppTypography.headlineMedium),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.pagePadding,
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xxl),

            // === PLAYER PRINCIPAL ===
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Column(
                children: [
                  // Logo radio
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.radio,
                      size: 52,
                      color: AppColors.textOnPrimary,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Nom radio
                  Text(
                    'Radio Ndeke Luka',
                    style: AppTypography.headlineLarge.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    'La voix du peuple centrafricain',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // Indicateur EN DIRECT
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: radioState.isPlaying
                          ? AppColors.error
                          : AppColors.textOnPrimary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (radioState.isPlaying)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.textOnPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        if (radioState.isPlaying)
                          const SizedBox(width: AppSpacing.xs),
                        Text(
                          radioState.isPlaying ? 'EN DIRECT' : 'HORS LIGNE',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Bouton Play/Pause
                  GestureDetector(
                    onTap: radioState.isLoading
                        ? null
                        : () =>
                            ref.read(radioProvider.notifier).togglePlayPause(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.textOnPrimary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: radioState.isLoading
                          ? Padding(
                              padding: const EdgeInsets.all(20),
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            )
                          : Icon(
                              radioState.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 40,
                              color: AppColors.primary,
                            ),
                    ),
                  ),

                  // Message erreur
                  if (radioState.hasError) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      radioState.errorMessage ?? 'Erreur de connexion',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // === AUTRES RADIOS (à venir) ===
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AUTRES RADIOS RCA',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _RadioItem(
                    name: 'Radio Centrafrique',
                    description: 'Radio nationale officielle',
                    isAvailable: false,
                  ),
                  const Divider(height: AppSpacing.xl),
                  _RadioItem(
                    name: 'Radio Fatima',
                    description: 'Radio catholique de Bangui',
                    isAvailable: false,
                  ),
                  const Divider(height: AppSpacing.xl),
                  _RadioItem(
                    name: 'Voix de l\'Amérique — RCA',
                    description: 'Service français pour la RCA',
                    isAvailable: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Info
            Text(
              'La radio nécessite une connexion internet.\nQualité : 128 kbps',
              style: AppTypography.caption.copyWith(
                color: AppColors.textHint,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _RadioItem extends StatelessWidget {
  final String name;
  final String description;
  final bool isAvailable;

  const _RadioItem({
    required this.name,
    required this.description,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isAvailable
                ? AppColors.primary.withValues(alpha: 0.08)
                : AppColors.lockedBg,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(
            Icons.radio,
            size: 20,
            color: isAvailable ? AppColors.primary : AppColors.locked,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTypography.bodyMedium.copyWith(
                  color:
                      isAvailable ? AppColors.textPrimary : AppColors.textHint,
                ),
              ),
              Text(description, style: AppTypography.caption),
            ],
          ),
        ),
        if (!isAvailable)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.lockedBg,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              'Bientôt',
              style: AppTypography.caption.copyWith(
                color: AppColors.locked,
              ),
            ),
          ),
      ],
    );
  }
}
