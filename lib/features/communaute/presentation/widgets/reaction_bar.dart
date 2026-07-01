// lib/features/communaute/presentation/widgets/reaction_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../providers/communaute_provider.dart';

class ReactionBar extends ConsumerWidget {
  final String postId;
  final int likes;
  final int supports;
  final int infos;

  const ReactionBar({
    super.key,
    required this.postId,
    required this.likes,
    required this.supports,
    required this.infos,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        _ReactionButton(
          icon: Icons.thumb_up_outlined,
          label: 'J\'aime',
          count: likes,
          onTap: () =>
              ref.read(communauteRepositoryProvider).react(postId, 'likes'),
        ),
        const SizedBox(width: AppSpacing.lg),
        _ReactionButton(
          icon: Icons.favorite_outline,
          label: 'Soutien',
          count: supports,
          onTap: () =>
              ref.read(communauteRepositoryProvider).react(postId, 'supports'),
        ),
        const SizedBox(width: AppSpacing.lg),
        _ReactionButton(
          icon: Icons.lightbulb_outline,
          label: 'Informatif',
          count: infos,
          onTap: () =>
              ref.read(communauteRepositoryProvider).react(postId, 'infos'),
        ),
      ],
    );
  }
}

class _ReactionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final VoidCallback onTap;

  const _ReactionButton({
    required this.icon,
    required this.label,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              count > 0 ? '$count' : label,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
