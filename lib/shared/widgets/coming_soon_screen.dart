// lib/shared/widgets/coming_soon_screen.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_typography.dart';

class ComingSoonScreen extends StatelessWidget {
  final String moduleName;
  final String moduleDescription;
  final IconData icon;

  const ComingSoonScreen({
    super.key,
    required this.moduleName,
    required this.moduleDescription,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(moduleName),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône sobre grisée
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.lockedBg,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  border: Border.all(
                    color: AppColors.border,
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: AppColors.locked,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Nom du module
              Text(
                moduleName,
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.sm),

              // Description
              Text(
                moduleDescription,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Séparateur décoratif sobre (inspiré du motif logo)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 1,
                    color: AppColors.secondary.withOpacity(0.4),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.diamond_outlined,
                    size: 12,
                    color: AppColors.secondary.withOpacity(0.6),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    width: 40,
                    height: 1,
                    color: AppColors.secondary.withOpacity(0.4),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Message
              Text(
                AppStrings.comingSoonDesc,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Bouton inactif grisé
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: null, // désactivé volontairement
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.locked,
                    side: const BorderSide(color: AppColors.border),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  child: Text(
                    AppStrings.comingSoon,
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.locked,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
