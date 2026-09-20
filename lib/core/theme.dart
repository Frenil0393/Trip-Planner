import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0066CC); // Action Blue
  static const Color primaryFocus = Color(0xFF0071E3);
  static const Color primaryOnDark = Color(0xFF2997FF);
  
  static const Color ink = Color(0xFF1D1D1F);
  static const Color bodyMuted = Color(0xFFD1D1D6); // Crisp Apple light silver
  static const Color bodyMutedDark = Color(0xFFB0B0B8);
  static const Color inkMuted80 = Color(0xFF333333);
  static const Color inkMuted48 = Color(0xFF7A7A7A);
  
  static const Color canvas = Color(0xFFFFFFFF);
  static const Color canvasParchment = Color(0xFFF5F5F7);
  static const Color surfacePearl = Color(0xFFFAFAFC);
  static const Color surfaceTile1 = Color(0xFF1C1C1E); // Apple dark background
  static const Color surfaceTile2 = Color(0xFF2C2C2E); // Apple dark card surface
  static const Color surfaceTile3 = Color(0xFF242426); // Slightly darker utility surface
  static const Color surfaceBlack = Color(0xFF000000);
  
  static const Color dividerSoft = Color(0xFFF0F0F0);
  static const Color hairline = Color(0xFFE0E0E0);
}

class AppTheme {
  static const String _fontFamily = 'system-ui';

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.canvas,
      cardColor: AppColors.canvas,
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
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.hairline, width: 1),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.canvas,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 15,
          color: AppColors.inkMuted80,
          height: 1.4,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.canvas,
        modalBackgroundColor: AppColors.canvas,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.canvas,
        headerBackgroundColor: AppColors.primary,
        headerForegroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          if (states.contains(WidgetState.disabled)) return Colors.black26;
          return AppColors.ink;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        todayForegroundColor: const WidgetStatePropertyAll(AppColors.primary),
        todayBorder: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          height: 1.15,
          color: AppColors.ink,
        ),
        displayMedium: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.35,
          height: 1.3,
          color: AppColors.ink,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          height: 1.25,
          color: AppColors.ink,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          height: 1.3,
          color: AppColors.ink,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: AppColors.ink,
        ),
        titleSmall: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.inkMuted80,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.25,
          height: 1.35,
          color: AppColors.ink,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
          height: 1.45,
          color: AppColors.ink,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.15,
          height: 1.4,
          color: AppColors.inkMuted80,
        ),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.2),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.canvas,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        hintStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.inkMuted48,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: Color(0x20000000)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: Color(0x20000000)),
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
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryOnDark,
      scaffoldBackgroundColor: AppColors.surfaceTile1,
      cardColor: AppColors.surfaceTile2,
      canvasColor: AppColors.surfaceTile1,
      fontFamily: _fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceTile1,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceTile2,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Colors.white12, width: 1),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceTile2,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.white12, width: 1),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 15,
          color: Color(0xFFE5E5EA),
          height: 1.4,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceTile2,
        modalBackgroundColor: AppColors.surfaceTile2,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.surfaceTile2,
        headerBackgroundColor: AppColors.primary,
        headerForegroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.white12, width: 1),
        ),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          if (states.contains(WidgetState.disabled)) return Colors.white24;
          return Colors.white;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        todayForegroundColor: const WidgetStatePropertyAll(AppColors.primaryOnDark),
        todayBorder: const BorderSide(color: AppColors.primaryOnDark, width: 1.5),
        yearForegroundColor: const WidgetStatePropertyAll(Colors.white),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          height: 1.15,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.35,
          height: 1.3,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          height: 1.25,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          height: 1.3,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: Colors.white,
        ),
        titleSmall: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFFD1D1D6),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.25,
          height: 1.35,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
          height: 1.45,
          color: Color(0xFFE5E5EA),
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.15,
          height: 1.4,
          color: Color(0xFFA1A1A6),
        ),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOnDark,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryOnDark,
          side: const BorderSide(color: AppColors.primaryOnDark, width: 1.2),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryOnDark,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceTile2,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        hintStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Color(0xFF8E8E93),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: AppColors.primaryOnDark, width: 2),
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryOnDark,
        surface: AppColors.surfaceTile2,
        onSurface: Colors.white,
        surfaceContainerHighest: AppColors.surfaceTile3,
      ),
    );
  }
}
