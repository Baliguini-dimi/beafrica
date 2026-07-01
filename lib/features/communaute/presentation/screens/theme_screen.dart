// lib/features/communaute/presentation/screens/theme_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../providers/communaute_provider.dart';
import '../widgets/post_card.dart';

class ThemeScreen extends ConsumerWidget {
  final String themeId;
  final String themeLabel;

  const ThemeScreen({
    super.key,
    required this.themeId,
    required this.themeLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(sortProvider);
    final postsAsync = ref.watch(postsProvider((theme: themeId, sort: sort)));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(themeLabel, style: AppTypography.headlineMedium),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: Column(
        children: [
          // Tri
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                _SortChip(
                  label: 'Récents',
                  isSelected: sort == 'recent',
                  onTap: () =>
                      ref.read(sortProvider.notifier).setSort('recent'),
                ),
                const SizedBox(width: AppSpacing.sm),
                _SortChip(
                  label: 'Populaires',
                  isSelected: sort == 'popular',
                  onTap: () =>
                      ref.read(sortProvider.notifier).setSort('popular'),
                ),
                const SizedBox(width: AppSpacing.sm),
                _SortChip(
                  label: 'Sans réponse',
                  isSelected: sort == 'unanswered',
                  onTap: () =>
                      ref.read(sortProvider.notifier).setSort('unanswered'),
                ),
              ],
            ),
          ),

          // Liste des posts
          Expanded(
            child: postsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Erreur de chargement',
                  style: AppTypography.bodyMedium,
                ),
              ),
              data: (posts) {
                if (posts.isEmpty) {
                  return Center(
                    child: Text(
                      'Aucune discussion pour l\'instant.\nSoyez le premier à publier !',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.separated(
                  padding: AppSpacing.pagePadding,
                  itemCount: posts.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostCard(
                      post: post,
                      onTap: () => context.push(
                        '${AppRouter.postDetail}/${post.id}',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => context.push(
          AppRouter.createPost,
          extra: {'themeId': themeId, 'themeLabel': themeLabel},
        ),
        child: const Icon(Icons.add, color: AppColors.textOnPrimary),
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
