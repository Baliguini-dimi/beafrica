// lib/features/home/presentation/screens/discover_more_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/locked_menu_tile.dart';

class DiscoverMoreScreen extends StatelessWidget {
  const DiscoverMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'À venir sur BéAfrica',
          style: AppTypography.headlineMedium,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Text(
            'VERSION 2',
            style: AppTypography.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const LockedMenuTile(
            moduleName: 'Tourisme interactif',
            moduleDescription: 'Lieux, itinéraires, cartes OpenStreetMap',
            icon: Icons.map_outlined,
            version: 'v2',
          ),
          const SizedBox(height: AppSpacing.md),
          const LockedMenuTile(
            moduleName: 'Réseau social',
            moduleDescription: 'Posts photos, stories, commentaires',
            icon: Icons.dynamic_feed_outlined,
            version: 'v2',
          ),
          const SizedBox(height: AppSpacing.md),
          const LockedMenuTile(
            moduleName: 'Éducation & Bourses',
            moduleDescription: 'Offres, universités, concours',
            icon: Icons.school_outlined,
            version: 'v2',
          ),
          const SizedBox(height: AppSpacing.md),
          const LockedMenuTile(
            moduleName: 'Musique & Artistes',
            moduleDescription: 'Streaming, albums, artistes RCA',
            icon: Icons.library_music_outlined,
            version: 'v2',
          ),

          const SizedBox(height: AppSpacing.xl),

          Text(
            'VERSION 3',
            style: AppTypography.caption.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const LockedMenuTile(
            moduleName: 'Investisseurs',
            moduleDescription: 'Mise en relation B2B',
            icon: Icons.handshake_outlined,
            version: 'v3',
          ),
          const SizedBox(height: AppSpacing.md),
          const LockedMenuTile(
            moduleName: 'Santé & Médecins',
            moduleDescription: 'Annuaire médical, urgences',
            icon: Icons.local_hospital_outlined,
            version: 'v3',
          ),
          const SizedBox(height: AppSpacing.md),
          const LockedMenuTile(
            moduleName: 'Transport & Mobilité',
            moduleDescription: 'Taxis, bus, covoiturage',
            icon: Icons.directions_bus_outlined,
            version: 'v3',
          ),

          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
