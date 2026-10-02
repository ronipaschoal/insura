import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  );

  /// Dark theme of the authenticated shell ([ResponsiveScaffold] and
  /// [InsuraAppBar]).
  static ThemeData get home => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.homeBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.loginAccent,
      brightness: Brightness.dark,
      surface: AppColors.homeSurface,
    ),
  );
}
