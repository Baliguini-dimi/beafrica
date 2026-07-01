// lib/features/communaute/presentation/screens/post_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../models/forum_post_model.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/communaute_provider.dart';
import '../widgets/reply_widget.dart';
import '../widgets/reaction_bar.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final _replyController = TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _sendReply(String authorName) async {
    if (_replyController.text.trim().isEmpty) return;

    final reply = ForumReplyModel(
      id: '',
      content: _replyController.text.trim(),
      authorId: 'current_user_id', // Sera remplacé par l'UID Firebase Auth
      authorName: authorName,
      createdAt: DateTime.now(),
    );

    await ref.read(communauteRepositoryProvider).addReply(widget.postId, reply);

    _replyController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final postAsync = ref.watch(postDetailProvider(widget.postId));
    final repliesAsync = ref.watch(repliesProvider(widget.postId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('Discussion', style: AppTypography.headlineMedium),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            onPressed: () {
              ref.read(communauteRepositoryProvider).reportPost(widget.postId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Signalement envoyé. Merci.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: postAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Text('Erreur de chargement', style: AppTypography.bodyMedium),
        ),
        data: (post) {
          if (post == null) {
            return Center(
              child: Text('Publication introuvable',
                  style: AppTypography.bodyMedium),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.pagePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.1),
                            child: Text(
                              post.authorName.isNotEmpty
                                  ? post.authorName[0].toUpperCase()
                                  : '?',
                              style: AppTypography.headlineSmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(post.authorName,
                                  style: AppTypography.labelLarge),
                              Text(
                                post.authorCountry ?? 'RCA',
                                style: AppTypography.caption,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(post.title, style: AppTypography.headlineLarge),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        post.content,
                        style: AppTypography.bodyLarge.copyWith(height: 1.7),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ReactionBar(
                        postId: post.id,
                        likes: post.likes,
                        supports: post.supports,
                        infos: post.infos,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      const Divider(),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Réponses (${post.replyCount})',
                        style: AppTypography.headlineMedium,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      repliesAsync.when(
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (e, _) => Text(
                          'Erreur de chargement',
                          style: AppTypography.bodySmall,
                        ),
                        data: (replies) {
                          if (replies.isEmpty) {
                            return Text(
                              'Aucune réponse pour l\'instant',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textHint,
                              ),
                            );
                          }
                          return Column(
                            children: replies
                                .map((r) => ReplyWidget(reply: r))
                                .toList(),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),

              // Input réponse
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(top: BorderSide(color: AppColors.divider)),
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _replyController,
                          style: AppTypography.bodyMedium,
                          decoration: const InputDecoration(
                            hintText: 'Votre réponse...',
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      GestureDetector(
                        onTap: () => _sendReply('Utilisateur'),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: AppColors.textOnPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
