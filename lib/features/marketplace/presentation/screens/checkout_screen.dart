// lib/features/marketplace/presentation/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../providers/cart_provider.dart';
import '../../providers/marketplace_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final cartItems = ref.read(cartProvider);
      final repository = ref.read(marketplaceRepositoryProvider);

      // Créer une commande par vendeur (simplifié : une commande par item)
      for (final item in cartItems) {
        await repository.createOrder({
          'productId': item.productId,
          'productTitle': item.productTitle,
          'buyerId': 'current_user_id', // Sera remplacé par l'UID Firebase Auth
          'buyerName': _nameController.text.trim(),
          'buyerPhone': _phoneController.text.trim(),
          'buyerAddress': _addressController.text.trim(),
          'buyerNote': _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
          'quantity': item.quantity,
          'totalPrice': item.subtotal,
          'status': 'pending',
          'sellerId': 'seller_id_placeholder',
          'createdAt': DateTime.now(),
        });
      }

      ref.read(cartProvider.notifier).clearCart();

      if (mounted) {
        context.go(AppRouter.marche);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Commande passée avec succès !'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final total = ref.read(cartProvider.notifier).total;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'Finaliser la commande',
          style: AppTypography.headlineMedium,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.pagePadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),

              // Récapitulatif
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Récapitulatif', style: AppTypography.headlineSmall),
                    const SizedBox(height: AppSpacing.md),
                    ...cartItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.productTitle} x${item.quantity}',
                                style: AppTypography.bodySmall,
                              ),
                            ),
                            Text(
                              '${_formatPrice(item.subtotal)} FCFA',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: AppTypography.headlineSmall),
                        Text(
                          '${_formatPrice(total)} FCFA',
                          style: AppTypography.headlineSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              Text('Vos informations', style: AppTypography.headlineSmall),
              const SizedBox(height: AppSpacing.lg),

              Text('Nom complet', style: AppTypography.labelLarge),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                style: AppTypography.bodyMedium,
                decoration: const InputDecoration(hintText: 'Votre nom'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Nom requis' : null,
              ),

              const SizedBox(height: AppSpacing.lg),

              Text('Téléphone', style: AppTypography.labelLarge),
              const SizedBox(height: 6),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: AppTypography.bodyMedium,
                decoration: const InputDecoration(hintText: 'Votre numéro'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Téléphone requis' : null,
              ),

              const SizedBox(height: AppSpacing.lg),

              Text('Adresse de livraison', style: AppTypography.labelLarge),
              const SizedBox(height: 6),
              TextFormField(
                controller: _addressController,
                style: AppTypography.bodyMedium,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Quartier, ville, points de repère',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Adresse requise' : null,
              ),

              const SizedBox(height: AppSpacing.lg),

              Text('Note (optionnel)', style: AppTypography.labelLarge),
              const SizedBox(height: 6),
              TextFormField(
                controller: _noteController,
                style: AppTypography.bodyMedium,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Précisions supplémentaires...',
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _placeOrder,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.textOnPrimary,
                            ),
                          ),
                        )
                      : const Text('Confirmer la commande'),
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
