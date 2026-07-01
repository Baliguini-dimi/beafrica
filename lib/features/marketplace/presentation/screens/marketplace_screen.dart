// lib/features/marketplace/presentation/screens/marketplace_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../data/marketplace_repository.dart';
import '../../providers/marketplace_provider.dart';
import '../../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';

class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = ref.watch(marketplaceCategoryProvider);
    final searchQuery = ref.watch(marketplaceSearchProvider);
    final productsAsync = ref.watch(productsProvider(
      category == 'tous' ? null : category,
    ));
    final cartCount = ref.watch(cartProvider.notifier).itemCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('Marché', style: AppTypography.headlineMedium),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => context.push(AppRouter.cart),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Recherche
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: TextField(
              controller: _searchController,
              onChanged: (q) =>
                  ref.read(marketplaceSearchProvider.notifier).search(q),
              style: AppTypography.bodyMedium,
              decoration: const InputDecoration(
                hintText: 'Rechercher un produit...',
                prefixIcon: Icon(Icons.search, size: 20),
              ),
            ),
          ),

          // Catégories
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: MarketplaceRepository.categories.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return CategoryChip(
                    label: 'Tous',
                    isSelected: category == 'tous',
                    onTap: () => ref
                        .read(marketplaceCategoryProvider.notifier)
                        .setCategory('tous'),
                  );
                }
                final cat = MarketplaceRepository.categories[index - 1];
                return CategoryChip(
                  label: cat['label']!,
                  isSelected: category == cat['id'],
                  onTap: () => ref
                      .read(marketplaceCategoryProvider.notifier)
                      .setCategory(cat['id']!),
                );
              },
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Grille produits
          Expanded(
            child: productsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Erreur de chargement',
                  style: AppTypography.bodyMedium,
                ),
              ),
              data: (products) {
                final filtered = searchQuery.isEmpty
                    ? products
                    : products
                        .where((p) => p.title
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.storefront_outlined,
                          size: 48,
                          color: AppColors.locked,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Aucun produit disponible',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: AppSpacing.pagePadding,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final product = filtered[index];
                    return ProductCard(
                      product: product,
                      onTap: () => context.push(
                        '${AppRouter.productDetail}/${product.id}',
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
        onPressed: () => context.push(AppRouter.addProduct),
        child: const Icon(Icons.add, color: AppColors.textOnPrimary),
      ),
    );
  }
}
