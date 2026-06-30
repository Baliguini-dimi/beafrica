// lib/features/dictionnaire/presentation/screens/dictionnaire_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../providers/dictionnaire_provider.dart';
import '../widgets/word_card.dart';

class DictionnaireScreen extends ConsumerStatefulWidget {
  const DictionnaireScreen({super.key});

  @override
  ConsumerState<DictionnaireScreen> createState() => _DictionnaireScreenState();
}

class _DictionnaireScreenState extends ConsumerState<DictionnaireScreen> {
  final _searchController = TextEditingController();
  String? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(dictionaryCategoriesProvider);
    final searchQuery = ref.watch(dictionnaireSearchProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text('Dictionnaire Sango', style: AppTypography.headlineMedium),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: categoriesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Text('Erreur de chargement', style: AppTypography.bodyMedium),
        ),
        data: (categories) {
          return Column(
            children: [
              // Recherche
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: TextField(
                  controller: _searchController,
                  onChanged: (q) {
                    ref.read(dictionnaireSearchProvider.notifier).search(q);
                    if (q.isNotEmpty) {
                      setState(() => _selectedCategory = null);
                    }
                  },
                  style: AppTypography.bodyMedium,
                  decoration: const InputDecoration(
                    hintText: 'Rechercher un mot français...',
                    prefixIcon: Icon(Icons.search, size: 20),
                  ),
                ),
              ),

              // Filtres catégories
              if (searchQuery.isEmpty)
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    itemCount: categories.length + 1,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        final isSelected = _selectedCategory == null;
                        return _CategoryChip(
                          label: 'Tous',
                          isSelected: isSelected,
                          onTap: () => setState(() => _selectedCategory = null),
                        );
                      }
                      final cat = categories[index - 1];
                      final isSelected = _selectedCategory == cat.id;
                      return _CategoryChip(
                        label: cat.label,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedCategory = cat.id),
                      );
                    },
                  ),
                ),

              const SizedBox(height: AppSpacing.lg),

              // Liste mots
              Expanded(
                child: Builder(
                  builder: (context) {
                    final allEntries =
                        categories.expand((c) => c.entries).toList();

                    var filtered = allEntries;

                    if (searchQuery.isNotEmpty) {
                      filtered = filtered
                          .where((e) =>
                              e.french
                                  .toLowerCase()
                                  .contains(searchQuery.toLowerCase()) ||
                              e.sango
                                  .toLowerCase()
                                  .contains(searchQuery.toLowerCase()))
                          .toList();
                    } else if (_selectedCategory != null) {
                      filtered = filtered
                          .where((e) => e.category == _selectedCategory)
                          .toList();
                    }

                    if (filtered.isEmpty) {
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
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        return WordCard(entry: filtered[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
