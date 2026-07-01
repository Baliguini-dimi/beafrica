// lib/features/marketplace/presentation/screens/seller_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../providers/marketplace_provider.dart';

class SellerScreen extends ConsumerWidget {
  const SellerScreen({super.key});

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sera remplacé par l'UID Firebase Auth réel une fois résolu
    const currentSellerId = 'current_user_id';
    final productsAsync = ref.watch(sellerProductsProvider(currentSellerId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('Mes annonces', style: AppTypography.headlineMedium),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            tooltip: 'Commandes reçues',
            onPressed: () => context.push(AppRouter.myOrders, extra: 'seller'),
          ),
        ],
      ),
      body: productsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Text('Erreur de chargement', style: AppTypography.bodyMedium),
        ),
        data: (products) {
          if (products.isEmpty) {
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
                    'Aucune annonce publiée',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton(
                    onPressed: () => context.push(AppRouter.addProduct),
                    child: const Text('Créer une annonce'),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: AppSpacing.pagePadding,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      child: Container(
                        width: 56,
                        height: 56,
                        color: AppColors.surfaceVariant,
                        child: product.imageUrls.isNotEmpty
                            ? Image.network(
                                product.imageUrls.first,
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.image_outlined,
                                color: AppColors.textHint,
                              ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: AppTypography.headlineSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_formatPrice(product.price)} FCFA',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (product.isActive
                                          ? AppColors.success
                                          : AppColors.textHint)
                                      .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusSm,
                              ),
                            ),
                            child: Text(
                              product.isActive ? 'Active' : 'Désactivée',
                              style: AppTypography.caption.copyWith(
                                color: product.isActive
                                    ? AppColors.success
                                    : AppColors.textHint,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: product.isActive,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        ref
                            .read(marketplaceRepositoryProvider)
                            .toggleProductStatus(product.id, value);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => context.push(AppRouter.addProduct),
        child: const Icon(Icons.add, color: AppColors.textOnPrimary),
      ),
    );
  }
}
