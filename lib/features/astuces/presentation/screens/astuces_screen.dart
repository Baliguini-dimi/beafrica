// lib/features/astuces/presentation/screens/astuces_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../providers/astuces_provider.dart';

class AstucesScreen extends ConsumerStatefulWidget {
  const AstucesScreen({super.key});

  @override
  ConsumerState<AstucesScreen> createState() => _AstucesScreenState();
}

class _AstucesScreenState extends ConsumerState<AstucesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(astucesCategoriesProvider);
    final searchQuery = ref.watch(astucesSearchProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('Astuces & Conseils', style: AppTypography.headlineMedium),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: TextField(
              controller: _searchController,
              onChanged: (q) =>
                  ref.read(astucesSearchProvider.notifier).search(q),
              style: AppTypography.bodyMedium,
              decoration: const InputDecoration(
                hintText: 'Rechercher un conseil...',
                prefixIcon: Icon(Icons.search, size: 20),
              ),
            ),
          ),
          Expanded(
            child: categoriesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => Center(
                child: Text('Erreur de chargement',
                    style: AppTypography.bodyMedium),
              ),
              data: (categories) {
                if (searchQuery.isNotEmpty) {
                  final allArticles = categories
                      .expand((c) => c.articles.map((a) => (a, c.icon)))
                      .where((tuple) => tuple.$1.title
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                      .toList();

                  if (allArticles.isEmpty) {
                    return Center(
                      child: Text(
                        'Aucun résultat trouvé',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: AppSpacing.pagePadding,
                    itemCount: allArticles.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final (article, icon) = allArticles[index];
                      return _buildAstuceCard(context, article, icon);
                    },
                  );
                }

                return ListView.builder(
                  padding: AppSpacing.pagePadding,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.label.toUpperCase(),
                            style: AppTypography.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          ...category.articles.map((article) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: AppSpacing.md),
                              child: _buildAstuceCard(
                                context,
                                article,
                                category.icon,
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAstuceCard(BuildContext context, article, String icon) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () => context.push(AppRouter.astuceDetail, extra: article),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(article.title, style: AppTypography.headlineSmall),
                      const SizedBox(height: 4),
                      Text(
                        'Mis à jour le ${article.updatedAt}',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textHint),
              ],
            ),
          ),
        );
      },
    );
  }
}
