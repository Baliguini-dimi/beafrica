// lib/features/meteo/presentation/widgets/forecast_item.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

class ForecastItem extends StatelessWidget {
  final Map<String, dynamic> forecast;

  const ForecastItem({super.key, required this.forecast});

  IconData _getIcon(String code) {
    if (code.startsWith('01')) return Icons.wb_sunny_outlined;
    if (code.startsWith('02')) return Icons.wb_cloudy;
    if (code.startsWith('03') || code.startsWith('04')) {
      return Icons.cloud_outlined;
    }
    if (code.startsWith('09') || code.startsWith('10')) return Icons.grain;
    if (code.startsWith('11')) return Icons.thunderstorm_outlined;
    return Icons.wb_cloudy_outlined;
  }

  String _formatTime(String dtTxt) {
    final parts = dtTxt.split(' ');
    if (parts.length < 2) return dtTxt;
    final timeParts = parts[1].split(':');
    return '${timeParts[0]}h';
  }

  String _formatDate(String dtTxt) {
    final date = DateTime.tryParse(dtTxt);
    if (date == null) return '';
    const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final temp = (forecast['main']['temp'] as num).round();
    final iconCode = forecast['weather'][0]['icon'] as String;
    final dtTxt = forecast['dt_txt'] as String;

    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            _formatDate(dtTxt),
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _formatTime(dtTxt),
            style: AppTypography.caption.copyWith(
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Icon(
            _getIcon(iconCode),
            size: 24,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$temp°',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
