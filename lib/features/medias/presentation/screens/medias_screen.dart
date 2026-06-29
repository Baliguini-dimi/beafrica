// lib/features/medias/presentation/screens/medias_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../providers/medias_provider.dart';
import '../widgets/article_card.dart';
import '../widgets/category_filter.dart';

class MediasScreen extends ConsumerStatefulWidget {
  const MediasScreen({super.key});

  @override
  ConsumerState<MediasScreen> createState() => _MediasScreenState();
}

class _MediasScreenState extends ConsumerState<MediasScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediasState = ref.watch(mediasProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('Médias & Actualités', style: AppTypography.headlineMedium),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () => ref.read(mediasProvider.notifier).loadArticles(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Bandeau offline
          if (mediasState.isOffline)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              color: AppColors.warning.withValues(alpha: 0.08),
              child: Row(
                children: [
                  const Icon(Icons.wifi_off_outlined,
                      size: 14, color: AppColors.warning),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Hors ligne · Données en cache',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
            ),

          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: TextField(
              controller: _searchController,
              onChanged: (q) => ref.read(mediasProvider.notifier).search(q),
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Rechercher un article...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(mediasProvider.notifier).search('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Filtres catégories
          CategoryFilter(
            selectedCategory: mediasState.selectedCategory,
            onCategoryChanged: (cat) =>
                ref.read(mediasProvider.notifier).filterByCategory(cat),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Contenu
          Expanded(
            child: mediasState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                : mediasState.error != null
                    ? _ErrorView(
                        message: mediasState.error!,
                        onRetry: () =>
                            ref.read(mediasProvider.notifier).loadArticles(),
                      )
                    : mediasState.filteredArticles.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.article_outlined,
                                  size: 48,
                                  color: AppColors.locked,
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                Text(
                                  'Aucun article disponible',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            color: AppColors.primary,
                            onRefresh: () => ref
                                .read(mediasProvider.notifier)
                                .loadArticles(),
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                              ),
                              itemCount: mediasState.filteredArticles.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: AppSpacing.md),
                              itemBuilder: (context, index) {
                                final article =
                                    mediasState.filteredArticles[index];
                                return ArticleCard(
                                  article: article,
                                  onTap: () => context.push(
                                    '/article',
                                    extra: article,
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_outlined,
              size: 48,
              color: AppColors.locked,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
