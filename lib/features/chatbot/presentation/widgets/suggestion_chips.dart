// lib/features/chatbot/presentation/widgets/suggestion_chips.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

class SuggestionChips extends StatelessWidget {
  final ValueChanged<String> onTap;

  const SuggestionChips({super.key, required this.onTap});

  static const List<String> suggestions = [
    'Parle-moi de l\'histoire de la RCA',
    'Quels plats traditionnels dois-je connaître ?',
    'Comment dit-on bonjour en Sango ?',
    'Quels sont les sites à visiter à Bangui ?',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggestions',
          style: AppTypography.caption.copyWith(
            color: AppColors.textHint,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: suggestions.map((s) {
            return GestureDetector(
              onTap: () => onTap(s),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  s,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
