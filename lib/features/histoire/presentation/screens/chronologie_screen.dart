// lib/features/histoire/presentation/screens/chronologie_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../providers/histoire_provider.dart';
import '../widgets/timeline_item.dart';

class ChronologieScreen extends ConsumerWidget {
  const ChronologieScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chronologieAsync = ref.watch(chronologieProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('Chronologie', style: AppTypography.headlineMedium),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: chronologieAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Text(
            'Erreur de chargement',
            style: AppTypography.bodyMedium,
          ),
        ),
        data: (events) => ListView.builder(
          padding: AppSpacing.pagePadding,
          itemCount: events.length,
          itemBuilder: (context, index) {
            return TimelineItem(
              event: events[index],
              isLast: index == events.length - 1,
            );
          },
        ),
      ),
    );
  }
}
