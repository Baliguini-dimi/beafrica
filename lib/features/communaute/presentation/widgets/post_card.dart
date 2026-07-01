// lib/features/communaute/presentation/widgets/post_card.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../models/forum_post_model.dart';

class PostCard extends StatelessWidget {
  final ForumPostModel post;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays}j';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Auteur
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    post.authorName.isNotEmpty
                        ? post.authorName[0].toUpperCase()
                        : '?',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.authorName, style: AppTypography.labelLarge),
                      Text(
                        '${post.authorCountry ?? 'RCA'} · ${_timeAgo(post.createdAt)}',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Titre
            Text(post.title, style: AppTypography.headlineSmall),

            const SizedBox(height: AppSpacing.xs),

            // Contenu
            Text(
              post.content,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: AppSpacing.md),

            // Stats
            Row(
              children: [
                const Icon(Icons.thumb_up_outlined,
                    size: 14, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text('${post.likes}', style: AppTypography.caption),
                const SizedBox(width: AppSpacing.lg),
                const Icon(Icons.chat_bubble_outline,
                    size: 14, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text('${post.replyCount} réponses',
                    style: AppTypography.caption),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
