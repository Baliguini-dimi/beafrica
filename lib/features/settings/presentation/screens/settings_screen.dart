// lib/features/settings/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('Paramètres', style: AppTypography.headlineMedium),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: ListView(
        children: [
          // === SECTION COMPTE ===
          _SectionHeader(title: 'Compte'),
          SettingsTile(
            icon: Icons.person_outline,
            title: 'Mon profil',
            subtitle: 'Modifier vos informations personnelles',
            onTap: () {
              // Sprint 2 — sera activé après Auth
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Disponible après connexion'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const Divider(height: 1, indent: 72),
          // === BANNIÈRE CONNEXION ===
Consumer(
  builder: (context, ref, _) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline, color: AppColors.primary, size: 32),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Non connecté', style: AppTypography.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  'Connectez-vous pour accéder à toutes les fonctionnalités',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          ElevatedButton(
            onPressed: () => context.push(AppRouter.login),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(80, 36),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text('Connexion', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  },
),

          // === SECTION APPARENCE ===
          _SectionHeader(title: 'Apparence'),
          SettingsTile(
            icon: Icons.language_outlined,
            title: 'Langue',
            subtitle: 'Français',
            onTap: () {
              _showLanguageDialog(context);
            },
          ),
          const Divider(height: 1, indent: 72),
          SettingsTile(
            icon: Icons.text_fields_outlined,
            title: 'Taille du texte',
            subtitle: 'Normale',
            onTap: () {
              _showTextSizeDialog(context);
            },
          ),
          const Divider(height: 1, indent: 72),

          // === SECTION NOTIFICATIONS ===
          _SectionHeader(title: 'Notifications'),
          SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications push',
            subtitle: 'Actualités et alertes communautaires',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (val) {
                setState(() => _notificationsEnabled = val);
              },
              activeColor: AppColors.primary,
            ),
          ),
          const Divider(height: 1, indent: 72),

          // === SECTION LÉGAL ===
          _SectionHeader(title: 'Légal'),
          SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Politique de confidentialité',
            onTap: () => context.push(AppRouter.privacy),
          ),
          const Divider(height: 1, indent: 72),
          SettingsTile(
            icon: Icons.description_outlined,
            title: 'Conditions d\'utilisation',
            onTap: () => context.push(AppRouter.privacy),
          ),
          const Divider(height: 1, indent: 72),

          // === SECTION À PROPOS ===
          _SectionHeader(title: 'À propos'),
          SettingsTile(
            icon: Icons.info_outline,
            title: 'À propos de BéAfrica',
            subtitle: 'Version 1.0.0',
            onTap: () => context.push(AppRouter.about),
          ),
          const Divider(height: 1, indent: 72),
          SettingsTile(
            icon: Icons.star_outline,
            title: 'Noter l\'application',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Merci pour votre soutien !'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const Divider(height: 1, indent: 72),
          SettingsTile(
            icon: Icons.share_outlined,
            title: 'Partager l\'application',
            onTap: () {},
          ),

          const SizedBox(height: AppSpacing.xxxl),

          // Version
          Center(
            child: Text(
              'BéAfrica v1.0.0\nFait avec ❤️ pour la RCA',
              style: AppTypography.caption,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Langue', style: AppTypography.headlineSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageOption(label: 'Français', isSelected: true),
            _LanguageOption(
                label: 'Sango (bientôt)', isSelected: false, disabled: true),
            _LanguageOption(
                label: 'English (bientôt)', isSelected: false, disabled: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showTextSizeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Taille du texte', style: AppTypography.headlineSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TextSizeOption(label: 'Petite', isSelected: false),
            _TextSizeOption(label: 'Normale', isSelected: true),
            _TextSizeOption(label: 'Grande', isSelected: false),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

// Widget section header
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool disabled;

  const _LanguageOption({
    required this.label,
    required this.isSelected,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(
          color: disabled ? AppColors.textHint : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColors.primary, size: 20)
          : null,
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}

class _TextSizeOption extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _TextSizeOption({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: AppTypography.bodyMedium),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColors.primary, size: 20)
          : null,
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}
