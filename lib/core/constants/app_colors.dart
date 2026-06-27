// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // === COULEURS PRIMAIRES ===
  static const Color primary = Color(0xFF1A6B3C);
  static const Color primaryLight = Color(0xFF2D8A54);
  static const Color primaryDark = Color(0xFF0F4A28);

  // === COULEURS SECONDAIRES ===
  static const Color secondary = Color(0xFFB8860B);
  static const Color secondaryLight = Color(0xFFD4A017);

  // === ACCENT ===
  static const Color accent = Color(0xFF1E3A6E);

  // === SURFACES ===
  static const Color background = Color(0xFFF8F6F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0EDE8);

  // === TEXTE ===
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF5C5C5C);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // === ÉTATS ===
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFC62828);
  static const Color warning = Color(0xFFE65100);
  static const Color info = Color(0xFF1565C0);

  // === BORDURES ===
  static const Color border = Color(0xFFDED9D2);
  static const Color divider = Color(0xFFEAE6E0);

  // === MODULES VERROUILLÉS ===
  static const Color locked = Color(0xFFBDBDBD);
  static const Color lockedBg = Color(0xFFF5F5F5);

  // === MODE SOMBRE (référence future) ===
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkPrimary = Color(0xFF4CAF7D);
}
