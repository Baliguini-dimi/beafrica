// lib/shared/widgets/beafrica_button.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

enum BeAfricaButtonType { primary, secondary, danger }

class BeAfricaButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final BeAfricaButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const BeAfricaButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = BeAfricaButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    Color bgColor;
    Color fgColor;
    Color borderColor;

    switch (type) {
      case BeAfricaButtonType.primary:
        bgColor = isDisabled ? AppColors.border : AppColors.primary;
        fgColor = AppColors.textOnPrimary;
        borderColor = Colors.transparent;
        break;
      case BeAfricaButtonType.secondary:
        bgColor = Colors.transparent;
        fgColor = isDisabled ? AppColors.locked : AppColors.primary;
        borderColor = isDisabled ? AppColors.border : AppColors.primary;
        break;
      case BeAfricaButtonType.danger:
        bgColor = isDisabled ? AppColors.border : AppColors.error;
        fgColor = AppColors.textOnPrimary;
        borderColor = Colors.transparent;
        break;
    }

    final button = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: fullWidth ? double.infinity : null,
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ] else if (icon != null) ...[
                  Icon(icon, size: 18, color: fgColor),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  label,
                  style: AppTypography.labelLarge.copyWith(color: fgColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return button;
  }
}
