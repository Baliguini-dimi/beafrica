// lib/features/marketplace/presentation/screens/product_detail_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../providers/marketplace_provider.dart';
import '../../providers/cart_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _currentImageIndex = 0;

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }

  Future<void> _contactWhatsApp(String phone, String productTitle) async {
    final message = Uri.encodeComponent(
      'Bonjour, je suis intéressé(e) par votre annonce "$productTitle" sur BéAfrica.',
    );
    final uri = Uri.parse('https://wa.me/$phone?text=$message');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: productAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Text('Erreur de chargement', style: AppTypography.bodyMedium),
        ),
        data: (product) {
          if (product == null) {
            return Center(
              child:
                  Text('Produit introuvable', style: AppTypography.bodyMedium),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.textPrimary,
                pinned: true,
                expandedHeight: 320,
                flexibleSpace: FlexibleSpaceBar(
                  background: product.imageUrls.isNotEmpty
                      ? Stack(
                          children: [
                            PageView.builder(
                              itemCount: product.imageUrls.length,
                              onPageChanged: (i) =>
                                  setState(() => _currentImageIndex = i),
                              itemBuilder: (context, index) {
                                return CachedNetworkImage(
                                  imageUrl: product.imageUrls[index],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: AppColors.surfaceVariant,
                                  ),
                                );
                              },
                            ),
                            if (product.imageUrls.length > 1)
                              Positioned(
                                bottom: 16,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    product.imageUrls.length,
                                    (i) => Container(
                                      width: 6,
                                      height: 6,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: i == _currentImageIndex
                                            ? Colors.white
                                            : Colors.white
                                                .withValues(alpha: 0.4),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )
                      : Container(
                          color: AppColors.surfaceVariant,
                          child: const Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 64,
                              color: AppColors.textHint,
                            ),
                          ),
                        ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.pagePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.lg),
                      Text(product.title, style: AppTypography.headlineLarge),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '${_formatPrice(product.price)} FCFA',
                        style: AppTypography.displayMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 16, color: AppColors.textHint),
                          const SizedBox(width: 4),
                          Text(product.city, style: AppTypography.bodySmall),
                          if (product.isVerifiedSeller) ...[
                            const SizedBox(width: AppSpacing.md),
                            const Icon(Icons.verified,
                                size: 16, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              'Vendeur vérifié',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      const Divider(),
                      const SizedBox(height: AppSpacing.lg),
                      Text('Description', style: AppTypography.headlineSmall),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        product.description,
                        style: AppTypography.bodyMedium.copyWith(height: 1.6),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.1),
                              child: Text(
                                product.sellerName.isNotEmpty
                                    ? product.sellerName[0].toUpperCase()
                                    : '?',
                                style: AppTypography.headlineSmall.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                product.sellerName,
                                style: AppTypography.labelLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: productAsync.maybeWhen(
        data: (product) {
          if (product == null) return null;
          return Container(
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
                    child: OutlinedButton.icon(
                      onPressed: () => _contactWhatsApp(
                        product.sellerWhatsapp,
                        product.title,
                      ),
                      icon: const Icon(Icons.chat_outlined, size: 18),
                      label: const Text('WhatsApp'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.read(cartProvider.notifier).addProduct(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ajouté au panier !'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                      label: const Text('Ajouter au panier'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        orElse: () => null,
      ),
    );
  }
}
