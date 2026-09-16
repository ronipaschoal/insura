import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF1E88E5);

  // Login screen branding: diagonal gradient header + dark floating card.
  static const Color loginGradientStart = Color(0xFF4FBFA0);
  static const Color loginGradientEnd = Color(0xFFE4D97C);
  static const Color loginBackgroundDark = Color(0xFF17181F);
  static const Color loginCardBackground = Color(0xFF272837);
  static const Color loginAccent = Color(0xFF2FBFA0);
  static const Color loginFieldBorder = Color(0x40FFFFFF);

  // Home screen branding: dark background/cards; welcome banner reuses the
  // login gradient for a consistent brand look across screens.
  static const Color homeBackground = Color(0xFF16171F);
  static const Color homeSurface = Color(0xFF20212C);
  static const Color homeCategoryTile = Color(0xFF262835);
  static const Color homeNotificationBadge = Color(0xFFE94F8A);
}
