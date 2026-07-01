// lib/features/communaute/presentation/screens/create_post_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../models/forum_post_model.dart';
import '../../providers/communaute_provider.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  final String themeId;
  final String themeLabel;

  const CreatePostScreen({
    super.key,
    required this.themeId,
    required this.themeLabel,
  });

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final post = ForumPostModel(
        id: '',
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        theme: widget.themeId,
        authorId: 'current_user_id', // Sera remplacé par l'UID Firebase Auth
        authorName: 'Utilisateur BéAfrica', // Sera remplacé par le profil
        authorCountry: null,
        createdAt: DateTime.now(),
      );

      await ref.read(communauteRepositoryProvider).createPost(post);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Publication créée avec succès !'),
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
        title:
            Text('Nouvelle publication', style: AppTypography.headlineMedium),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _publish,
            child: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Publier',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.pagePadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),

              // Badge thème
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  widget.themeLabel,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Titre
              Text('Titre', style: AppTypography.labelLarge),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                style: AppTypography.bodyMedium,
                maxLength: 100,
                decoration: const InputDecoration(
                  hintText: 'Donnez un titre à votre publication',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Titre requis';
                  }
                  if (value.trim().length < 5) {
                    return 'Titre trop court (minimum 5 caractères)';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // Contenu
              Text('Contenu', style: AppTypography.labelLarge),
              const SizedBox(height: 6),
              TextFormField(
                controller: _contentController,
                style: AppTypography.bodyMedium,
                maxLines: 8,
                maxLength: 2000,
                decoration: const InputDecoration(
                  hintText: 'Partagez votre message avec la communauté...',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Contenu requis';
                  }
                  if (value.trim().length < 10) {
                    return 'Message trop court (minimum 10 caractères)';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // Info modération
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: AppColors.info.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.info,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Soyez respectueux. Les publications inappropriées peuvent être signalées et supprimées.',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
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
