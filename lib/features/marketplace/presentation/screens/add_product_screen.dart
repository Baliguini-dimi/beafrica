// lib/features/marketplace/presentation/screens/add_product_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../models/product_model.dart';
import '../../data/marketplace_repository.dart';
import '../../providers/marketplace_provider.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _cityController = TextEditingController();
  final _whatsappController = TextEditingController();

  String? _selectedCategory;
  final List<File> _selectedImages = [];
  bool _isLoading = false;

  final _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _cityController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 3 photos par annonce'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
      maxWidth: 1200,
    );

    if (picked != null) {
      setState(() => _selectedImages.add(File(picked.path)));
    }
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sélectionnez une catégorie'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ajoutez au moins une photo'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(marketplaceRepositoryProvider);

      // 1. Créer le produit sans images d'abord pour obtenir un ID
      final product = ProductModel(
        id: '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        category: _selectedCategory!,
        imageUrls: [],
        city: _cityController.text.trim(),
        sellerId: 'current_user_id', // Sera remplacé par l'UID Firebase Auth
        sellerName: 'Vendeur BéAfrica', // Sera remplacé par le profil
        sellerWhatsapp: _whatsappController.text.trim(),
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );

      final productId = await repository.createProduct(product);

      // 2. Upload des images
      final List<String> imageUrls = [];
      for (int i = 0; i < _selectedImages.length; i++) {
        final url = await repository.uploadImage(
          _selectedImages[i],
          productId,
          i,
        );
        imageUrls.add(url);
      }

      // 3. Mettre à jour le produit avec les URLs d'images
      await repository.updateProductImages(productId, imageUrls);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Annonce publiée avec succès !'),
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text('Nouvelle annonce', style: AppTypography.headlineMedium),
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

              // Photos
              Text('Photos (max 3)', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ..._selectedImages.asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusSm,
                              ),
                              child: Image.file(
                                entry.value,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(entry.key),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    if (_selectedImages.length < 3)
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusSm,
                            ),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(
                            Icons.add_photo_alternate_outlined,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Titre
              Text('Titre de l\'annonce', style: AppTypography.labelLarge),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                style: AppTypography.bodyMedium,
                decoration: const InputDecoration(
                  hintText: 'Ex : Panier artisanal en osier',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Titre requis' : null,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Catégorie
              Text('Catégorie', style: AppTypography.labelLarge),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: Text(
                  'Sélectionner',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
                items: MarketplaceRepository.categories.map((c) {
                  return DropdownMenuItem(
                    value: c['id'],
                    child: Text(c['label']!, style: AppTypography.bodyMedium),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Prix
              Text('Prix (FCFA)', style: AppTypography.labelLarge),
              const SizedBox(height: 6),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                style: AppTypography.bodyMedium,
                decoration: const InputDecoration(hintText: 'Ex : 5000'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Prix requis';
                  if (double.tryParse(v) == null) return 'Prix invalide';
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // Ville
              Text('Ville', style: AppTypography.labelLarge),
              const SizedBox(height: 6),
              TextFormField(
                controller: _cityController,
                style: AppTypography.bodyMedium,
                decoration: const InputDecoration(hintText: 'Ex : Bangui'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ville requise' : null,
              ),

              const SizedBox(height: AppSpacing.lg),

              // WhatsApp
              Text('Numéro WhatsApp', style: AppTypography.labelLarge),
              const SizedBox(height: 6),
              TextFormField(
                controller: _whatsappController,
                keyboardType: TextInputType.phone,
                style: AppTypography.bodyMedium,
                decoration: const InputDecoration(
                  hintText: 'Ex : 23670000000 (avec indicatif, sans +)',
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Numéro WhatsApp requis'
                    : null,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Description
              Text('Description', style: AppTypography.labelLarge),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                style: AppTypography.bodyMedium,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Décrivez votre produit en détail...',
                  alignLabelWithHint: true,
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Description requise'
                    : null,
              ),

              const SizedBox(height: AppSpacing.xxl),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
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
                      : const Text('Publier l\'annonce'),
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
