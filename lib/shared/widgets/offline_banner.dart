// lib/shared/widgets/offline_banner.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

// Provider de connectivité — sera branché sur connectivity_plus au Sprint 3
// Pour l'instant, on le déclare ici simplement
final isOnlineProvider = StateProvider<bool>((ref) => true);

class OfflineBanner extends ConsumerWidget {
  final String? cacheDate;

  const OfflineBanner({super.key, this.cacheDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);

    if (isOnline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      color: AppColors.warning.withOpacity(0.08),
      child: Row(
        children: [
          Icon(
            Icons.wifi_off_outlined,
            size: 14,
            color: AppColors.warning,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              cacheDate != null
                  ? 'Hors ligne · Données du $cacheDate'
                  : 'Hors ligne · Certaines données peuvent être obsolètes',
              style: AppTypography.caption.copyWith(
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
