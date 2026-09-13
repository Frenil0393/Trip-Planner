import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0066CC); // Action Blue
  static const Color primaryFocus = Color(0xFF0071E3);
  static const Color primaryOnDark = Color(0xFF2997FF);
  
  static const Color ink = Color(0xFF1D1D1F);
  static const Color bodyMuted = Color(0xFFCCCCCC);
  static const Color inkMuted80 = Color(0xFF333333);
  static const Color inkMuted48 = Color(0xFF7A7A7A);
  
  static const Color canvas = Color(0xFFFFFFFF);
  static const Color canvasParchment = Color(0xFFF5F5F7);
  static const Color surfacePearl = Color(0xFFFAFAFC);
  static const Color surfaceTile1 = Color(0xFF272729);
  static const Color surfaceTile2 = Color(0xFF2A2A2C);
  static const Color surfaceTile3 = Color(0xFF252527);
  static const Color surfaceBlack = Color(0xFF000000);
  
  static const Color dividerSoft = Color(0xFFF0F0F0);
  static const Color hairline = Color(0xFFE0E0E0);
}

class AppTheme {
  // SF Pro Text & Display approximations using system UI fonts
  static const String _fontFamily = 'system-ui';

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.canvas,
      fontFamily: _fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.ink),
      ),
      cardTheme: CardThemeData(
        color: AppColors.canvas,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18), // rounded.lg
          side: const BorderSide(color: AppColors.hairline, width: 1),
        ),
      ),
      textTheme: const TextTheme(
        // display-lg
        displayLarge: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.1,
          color: AppColors.ink,
        ),
        // display-md
        displayMedium: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.374,
          height: 1.47,
          color: AppColors.ink,
        ),
        // lead
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.196,
          height: 1.14,
          color: AppColors.ink,
        ),
        // tagline
        titleLarge: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.231,
          height: 1.19,
          color: AppColors.ink,
        ),
        // body-strong
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.374,
          height: 1.24,
          color: AppColors.ink,
        ),
        // body
        bodyMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.374,
          height: 1.47,
          color: AppColors.ink,
        ),
        // caption
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.224,
          height: 1.43,
          color: AppColors.inkMuted80,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.canvas,
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.374,
          ),
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999), // rounded.pill
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.374,
          ),
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.374,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.canvas,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        hintStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.374,
          color: AppColors.inkMuted48,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: Color(0x14000000)), // rgba(0,0,0,0.08)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: Color(0x14000000)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: AppColors.primaryFocus, width: 2),
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        surface: AppColors.canvas,
        onSurface: AppColors.ink,
      ),
    );
  }

  static ThemeData get darkTheme {
    // Creating a base for dark theme mirroring the tile-1 colors
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.surfaceTile1,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceTile1,
        foregroundColor: AppColors.canvas,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.canvas),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceTile2,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Colors.transparent),
        ),
      ),
      textTheme: lightTheme.textTheme.apply(
        bodyColor: AppColors.canvas,
        displayColor: AppColors.canvas,
      ),
      inputDecorationTheme: lightTheme.inputDecorationTheme.copyWith(
        fillColor: AppColors.surfaceTile2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryOnDark,
        surface: AppColors.surfaceTile1,
        onSurface: AppColors.canvas,
      ),
    );
  }
}
