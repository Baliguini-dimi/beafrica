// lib/features/home/presentation/widgets/quick_access_grid.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  static const List<Map<String, dynamic>> _items = [
    {
      'label': 'Météo',
      'icon': Icons.wb_sunny_outlined,
      'route': AppRouter.meteo,
      'color': Color(0xFF1565C0),
    },
    {
      'label': 'Devises',
      'icon': Icons.currency_exchange,
      'route': AppRouter.devises,
      'color': Color(0xFF2E7D32),
    },
    {
      'label': 'Dictionnaire',
      'icon': Icons.menu_book_outlined,
      'route': AppRouter.dictionnaire,
      'color': Color(0xFFB8860B),
    },
    {
      'label': 'Ndàrà IA',
      'icon': Icons.chat_outlined,
      'route': AppRouter.chatbot,
      'color': Color(0xFF1A6B3C),
    },
    {
      'label': 'Culture',
      'icon': Icons.palette_outlined,
      'route': AppRouter.culture,
      'color': Color(0xFFE65100),
    },
    {
      'label': 'Astuces',
      'icon': Icons.lightbulb_outlined,
      'route': AppRouter.astuces,
      'color': Color(0xFF6A1B9A),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.1,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return _QuickAccessItem(
          label: item['label'] as String,
          icon: item['icon'] as IconData,
          color: item['color'] as Color,
          onTap: () => context.push(item['route'] as String),
        );
      },
    );
  }
}

class _QuickAccessItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
