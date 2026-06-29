// lib/features/settings/presentation/screens/privacy_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('Politique de confidentialité',
            style: AppTypography.headlineMedium),
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
            Text(
              'Politique de Confidentialité',
              style: AppTypography.headlineLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Dernière mise à jour : Juin 2026',
              style: AppTypography.caption,
            ),
            const SizedBox(height: AppSpacing.xl),
            _PolicySection(
              title: '1. Collecte des données',
              content:
                  'BéAfrica collecte uniquement les données nécessaires au bon fonctionnement de l\'application : adresse email, nom d\'affichage et pays de résidence lors de l\'inscription. Ces données sont stockées de manière sécurisée via Firebase (Google).',
            ),
            _PolicySection(
              title: '2. Utilisation des données',
              content:
                  'Vos données sont utilisées exclusivement pour personnaliser votre expérience sur BéAfrica. Nous ne vendons, ne louons et ne partageons jamais vos données personnelles avec des tiers à des fins commerciales.',
            ),
            _PolicySection(
              title: '3. Données hors ligne',
              content:
                  'BéAfrica stocke certaines données en local sur votre appareil (cache des actualités, taux de change, météo) pour garantir un fonctionnement hors connexion. Ces données sont purement fonctionnelles et ne sont pas transmises.',
            ),
            _PolicySection(
              title: '4. APIs tierces',
              content:
                  'L\'application utilise des services tiers : Firebase (authentification et base de données), OpenWeatherMap (météo), ExchangeRate-API (devises) et Groq API (assistant IA). Chacun de ces services dispose de sa propre politique de confidentialité.',
            ),
            _PolicySection(
              title: '5. Sécurité',
              content:
                  'Nous mettons en œuvre des mesures de sécurité appropriées pour protéger vos données contre tout accès non autorisé. Les clés API et informations sensibles ne sont jamais stockées dans le code source.',
            ),
            _PolicySection(
              title: '6. Droits des utilisateurs',
              content:
                  'Vous avez le droit d\'accéder à vos données, de les modifier ou de les supprimer à tout moment depuis votre profil. Pour toute demande, contactez-nous à l\'adresse indiquée ci-dessous.',
            ),
            _PolicySection(
              title: '7. Contact',
              content:
                  'Pour toute question relative à cette politique de confidentialité, contactez le développeur : Dimitri Nelson BALIGUINI DEMBA  [dbaliguini@gmail.com]',
            ),
            const SizedBox(height: AppSpacing.xxl),
            const Divider(),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: Text(
                '© 2026 BéAfrica\n Par LEGACY Inc [Dimitri BALIGUINI]',
                style: AppTypography.caption,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String content;

  const _PolicySection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            content,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
