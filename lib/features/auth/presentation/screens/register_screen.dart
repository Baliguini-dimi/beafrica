// lib/features/auth/presentation/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../providers/auth_provider.dart';
import '../widgets/auth_form_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _selectedCountry;

  final List<String> _countries = [
    'République Centrafricaine',
    'France',
    'Belgique',
    'Canada',
    'Cameroun',
    'Congo (RDC)',
    'Congo (Brazzaville)',
    'Côte d\'Ivoire',
    'Gabon',
    'Sénégal',
    'Mali',
    'Burkina Faso',
    'Tchad',
    'Soudan',
    'États-Unis',
    'Autre',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
          country: _selectedCountry,
        );

    if (success && mounted) {
      context.go(AppRouter.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.pagePadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),

                // Titre
                Text('Créer un compte', style: AppTypography.displayMedium),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Rejoignez la communauté BéAfrica',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Nom complet
                AuthFormField(
                  label: 'Nom complet',
                  hint: 'Votre nom et prénom',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nom requis';
                    }
                    if (value.length < 2) {
                      return 'Nom trop court';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.lg),

                // Email
                AuthFormField(
                  label: 'Adresse email',
                  hint: 'votre@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email requis';
                    }
                    if (!value.contains('@')) {
                      return 'Email invalide';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.lg),

                // Pays
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pays de résidence', style: AppTypography.labelLarge),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedCountry,
                      hint: Text(
                        'Sélectionner un pays',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.flag_outlined,
                          size: 20,
                          color: AppColors.textHint,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceVariant,
                      ),
                      items: _countries.map((country) {
                        return DropdownMenuItem(
                          value: country,
                          child: Text(country, style: AppTypography.bodyMedium),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedCountry = value);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // Mot de passe
                AuthFormField(
                  label: 'Mot de passe',
                  hint: 'Minimum 6 caractères',
                  controller: _passwordController,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mot de passe requis';
                    }
                    if (value.length < 6) {
                      return 'Minimum 6 caractères';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.lg),

                // Confirmer mot de passe
                AuthFormField(
                  label: 'Confirmer le mot de passe',
                  hint: 'Répétez le mot de passe',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirmation requise';
                    }
                    if (value != _passwordController.text) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Message d'erreur
                if (authState.errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      authState.errorMessage!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Bouton inscription
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: authState.isLoading ? null : _register,
                    child: authState.isLoading
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
                        : const Text('Créer mon compte'),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Déjà un compte
                Center(
                  child: TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      'Déjà un compte ? Se connecter',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
