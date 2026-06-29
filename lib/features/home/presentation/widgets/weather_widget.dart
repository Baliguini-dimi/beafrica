// lib/features/home/presentation/widgets/weather_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../home/providers/home_provider.dart';

class WeatherWidget extends ConsumerWidget {
  const WeatherWidget({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: homeState.isLoadingWeather
          ? const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.textOnPrimary,
                  ),
                ),
              ),
            )
          : homeState.weatherError != null || homeState.weather == null
              ? Row(
                  children: [
                    const Icon(
                      Icons.wb_sunny_outlined,
                      color: AppColors.textOnPrimary,
                      size: 32,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bangui',
                          style: AppTypography.headlineSmall.copyWith(
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                        Text(
                          'Données indisponibles',
                          style: AppTypography.bodySmall.copyWith(
                            color:
                                AppColors.textOnPrimary.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : _WeatherContent(
                  weather: homeState.weather!,
                  getIcon: _getWeatherIcon,
                ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  final Map<String, dynamic> weather;
  final IconData Function(String) getIcon;

  const _WeatherContent({required this.weather, required this.getIcon});

  @override
  Widget build(BuildContext context) {
    final temp = (weather['main']['temp'] as num).round();
    final feels = (weather['main']['feels_like'] as num).round();
    final humidity = weather['main']['humidity'];
    final description = weather['weather'][0]['description'] as String;
    final iconCode = weather['weather'][0]['icon'] as String;

    return Row(
      children: [
        Icon(getIcon(iconCode), color: AppColors.textOnPrimary, size: 40),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$temp°',
                    style: AppTypography.displayMedium.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      'Bangui',
                      style: AppTypography.headlineSmall.copyWith(
                        color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                description,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Ressenti $feels°',
              style: AppTypography.caption.copyWith(
                color: AppColors.textOnPrimary.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Humidité $humidity%',
              style: AppTypography.caption.copyWith(
                color: AppColors.textOnPrimary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
