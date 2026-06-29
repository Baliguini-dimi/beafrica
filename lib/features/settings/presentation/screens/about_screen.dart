// lib/features/settings/presentation/screens/about_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('À propos', style: AppTypography.headlineMedium),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // === HEADER APP ===
            Container(
              width: double.infinity,
              color: AppColors.surface,
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo/beafrica_logo.png',
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'BéAfrica',
                    style: AppTypography.displayMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Découvrez le cœur de l\'Afrique.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Badge version
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(
                      'Version 1.0.0',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // === SÉPARATEUR DÉCORATIF ===
            _Separator(),

            const SizedBox(height: AppSpacing.lg),

            // === LE CONCEPTEUR ===
            Container(
              width: double.infinity,
              color: AppColors.surface,
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'LE CONCEPTEUR',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Photo de profil
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2.5,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/about/developer.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Nom
                  Text(
                    'Dimitri Nelson BALIGUINI DEMBA',
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // Alias
                  Text(
                    'Dem\'s',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.secondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Infos
                  _InfoChip(
                    icon: Icons.school_outlined,
                    label: 'Developpeur Full-Stack & Expert IT',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _InfoChip(
                    icon: Icons.flag_outlined,
                    label: 'Côte d\'Ivoire République Centrafricaine',
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Boutons contact
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ContactButton(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        onTap: () {},
                      ),
                      const SizedBox(width: AppSpacing.md),
                      _ContactButton(
                        icon: Icons.code,
                        label: 'GitHub',
                        onTap: () {},
                      ),
                      const SizedBox(width: AppSpacing.md),
                      _ContactButton(
                        icon: Icons.work_outline,
                        label: 'LinkedIn',
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Citation
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      '"BéAfrica est né d\'un amour profond pour la République Centrafricaine et d\'une volonté de connecter notre peuple à travers le digital."',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            _Separator(),

            const SizedBox(height: AppSpacing.lg),

            // === INFORMATIONS APP ===
            Container(
              width: double.infinity,
              color: AppColors.surface,
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'L\'APPLICATION',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _AppInfoRow(label: 'Nom', value: 'BéAfrica'),
                  _AppInfoRow(label: 'Version', value: '1.0.0'),
                  _AppInfoRow(label: 'Plateforme', value: 'Android'),
                  _AppInfoRow(label: 'Langue principale', value: 'Français'),
                  _AppInfoRow(
                      label: 'Pays cible', value: 'République Centrafricaine'),
                  _AppInfoRow(label: 'Année', value: '2026'),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // === REMERCIEMENTS ===
            Container(
              width: double.infinity,
              color: AppColors.surface,
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'REMERCIEMENTS',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'À toute la communauté centrafricaine de la diaspora et aux locaux qui nous ont inspiré ce projet. À l\'IUA d\'Abidjan pour la formation. À tous ceux qui croient en l\'Afrique numérique.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Footer
            Text(
              '© 2026 BéAfrica\n Par LEGACY Inc [Dimitri BALIGUINI]',
              style: AppTypography.caption,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

// Widgets helper
class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 40,
            height: 1,
            color: AppColors.secondary.withValues(alpha: 0.4)),
        const SizedBox(width: AppSpacing.sm),
        Icon(Icons.diamond_outlined,
            size: 12, color: AppColors.secondary.withValues(alpha: 0.6)),
        const SizedBox(width: AppSpacing.sm),
        Container(
            width: 40,
            height: 1,
            color: AppColors.secondary.withValues(alpha: 0.4)),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(label, style: AppTypography.caption),
          ],
        ),
      ),
    );
  }
}

class _AppInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _AppInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              )),
          Text(value,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }
}
