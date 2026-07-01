// lib/features/communaute/presentation/widgets/reply_widget.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../models/forum_post_model.dart';

class ReplyWidget extends StatelessWidget {
  final ForumReplyModel reply;

  const ReplyWidget({super.key, required this.reply});

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    return 'Il y a ${diff.inDays}j';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  reply.authorName.isNotEmpty
                      ? reply.authorName[0].toUpperCase()
                      : '?',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(reply.authorName, style: AppTypography.labelMedium),
              const SizedBox(width: AppSpacing.sm),
              Text(_timeAgo(reply.createdAt), style: AppTypography.caption),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            reply.content,
            style: AppTypography.bodySmall.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
