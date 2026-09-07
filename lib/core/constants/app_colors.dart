import 'package:flutter/material.dart';

/// Safaricom M-Pesa brand colors and semantic aliases.
class AppColors {
  AppColors._();

  // ── Brand Primary ──
  static const Color primaryGreen = Color(0xFF00A650);
  static const Color darkGreen = Color(0xFF006B3F);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color accentGreen = Color(0xFF4CAF50);

  // ── Brand Secondary ──
  static const Color safaricomRed = Color(0xFFE31937);
  static const Color safaricomBlue = Color(0xFF1A73E8);

  // ── Neutrals ──
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ── Semantic ──
  static const Color surface = white;
  static const Color onSurface = grey900;
  static const Color surfaceVariant = grey100;
  static const Color divider = grey200;
  static const Color shimmerBase = grey200;
  static const Color shimmerHighlight = grey100;
  static const Color error = safaricomRed;
  static const Color success = primaryGreen;
  static const Color warning = Color(0xFFFFA000);
  static const Color info = safaricomBlue;

  // ── Background ──
  static const Color scaffoldBackground = Color(0xFFF5F7FA);
  static const Color cardBackground = white;

  // ── Gradients ──
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, darkGreen],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkGreen, primaryGreen],
  );
}
