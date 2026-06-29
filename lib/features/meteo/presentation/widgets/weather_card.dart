// lib/features/meteo/presentation/widgets/weather_card.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({super.key, required this.weather});

  IconData _getWeatherIcon(String code) {
    if (code.startsWith('01')) return Icons.wb_sunny_outlined;
    if (code.startsWith('02')) return Icons.wb_cloudy;
    if (code.startsWith('03') || code.startsWith('04')) {
      return Icons.cloud_outlined;
    }
    if (code.startsWith('09') || code.startsWith('10')) return Icons.grain;
    if (code.startsWith('11')) return Icons.thunderstorm_outlined;
    if (code.startsWith('50')) return Icons.foggy;
    return Icons.wb_cloudy_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ville + icône
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                weather.city,
                style: AppTypography.headlineLarge.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              ),
              Icon(
                _getWeatherIcon(weather.iconCode),
                color: AppColors.textOnPrimary,
                size: 48,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Température principale
          Text(
            '${weather.temperature.round()}°C',
            style: AppTypography.displayLarge.copyWith(
              color: AppColors.textOnPrimary,
              fontSize: 48,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // Description
          Text(
            weather.description,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textOnPrimary.withValues(alpha: 0.85),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Divider
          Divider(
            color: AppColors.textOnPrimary.withValues(alpha: 0.2),
            height: 1,
          ),

          const SizedBox(height: AppSpacing.lg),

          // Détails
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _DetailItem(
                icon: Icons.thermostat_outlined,
                label: 'Ressenti',
                value: '${weather.feelsLike.round()}°',
              ),
              _DetailItem(
                icon: Icons.water_drop_outlined,
                label: 'Humidité',
                value: '${weather.humidity}%',
              ),
              _DetailItem(
                icon: Icons.air_outlined,
                label: 'Vent',
                value: '${weather.windSpeed.round()} m/s',
              ),
              _DetailItem(
                icon: Icons.arrow_downward,
                label: 'Min',
                value: '${weather.tempMin.round()}°',
              ),
              _DetailItem(
                icon: Icons.arrow_upward,
                label: 'Max',
                value: '${weather.tempMax.round()}°',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon,
            color: AppColors.textOnPrimary.withValues(alpha: 0.8), size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.textOnPrimary,
          ),
        ),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textOnPrimary.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
