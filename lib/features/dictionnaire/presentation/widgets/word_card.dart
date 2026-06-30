// lib/features/dictionnaire/presentation/widgets/word_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../models/dictionary_entry_model.dart';
import '../../providers/dictionnaire_provider.dart';

class WordCard extends ConsumerWidget {
  final DictionaryEntryModel entry;

  const WordCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(dictionaryFavoritesProvider);
    final isFavorite = favorites.contains(entry.id);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.french,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(entry.sango, style: AppTypography.sangoWord),
                const SizedBox(height: 2),
                Text(entry.phonetic, style: AppTypography.sangoPhonetic),
                if (entry.example != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    entry.example!,
                    style: AppTypography.caption.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? AppColors.secondary : AppColors.textHint,
            ),
            onPressed: () =>
                ref.read(dictionaryFavoritesProvider.notifier).toggle(entry.id),
          ),
        ],
      ),
    );
  }
}
