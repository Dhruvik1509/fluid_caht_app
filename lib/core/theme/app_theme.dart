// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  // ─────────────────────────────────────────────
  // LIGHT THEME
  // ─────────────────────────────────────────────
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceVariant: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
        surfaceContainerLowest: AppColors.surfaceContainerLowest,
        surfaceContainerLow: AppColors.surfaceContainerLow,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerHigh: AppColors.surfaceContainerHigh,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
      ),

      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Inter',
      textTheme: _textTheme(AppColors.onSurface, AppColors.onSurfaceVariant, AppColors.outline),

      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.onSurface,
        titleTextStyle: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 20,
          height: 26 / 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
          color: AppColors.onSurface,
        ),
        iconTheme: IconThemeData(color: AppColors.onSurfaceVariant),
        actionsIconTheme: IconThemeData(color: AppColors.onSurfaceVariant),
      ),

      inputDecorationTheme: _inputDecorationTheme(
        fill: AppColors.surfaceContainerLowest,
        hint: AppColors.outline,
        border: AppColors.outlineVariant,
        focused: AppColors.primary,
        error: AppColors.error,
        label: AppColors.onSurfaceVariant,
        floatingLabel: AppColors.primary,
      ),

      elevatedButtonTheme: _elevatedButtonTheme(AppColors.primary, AppColors.onPrimary),
      filledButtonTheme: _filledButtonTheme(AppColors.primary, AppColors.onPrimary),
      outlinedButtonTheme: _outlinedButtonTheme(AppColors.outlineVariant, AppColors.onSurface),
      textButtonTheme: _textButtonTheme(AppColors.primary),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        selectedLabelStyle: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      snackBarTheme: SnackBarThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.inverseSurface,
        contentTextStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.inverseOnSurface,
        ),
        actionTextColor: AppColors.primaryFixedDim,
      ),

      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        backgroundColor: AppColors.surfaceContainerLow,
        disabledColor: AppColors.surfaceContainerHighest,
        selectedColor: AppColors.primaryContainer,
        labelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant),
        brightness: Brightness.light,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: AppColors.surface,
        selectedIconTheme: IconThemeData(color: AppColors.primary),
        unselectedIconTheme: IconThemeData(color: AppColors.onSurfaceVariant),
        selectedLabelTextStyle: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary),
        unselectedLabelTextStyle: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        circularTrackColor: AppColors.surfaceContainerHighest,
        linearTrackColor: AppColors.surfaceContainerHighest,
      ),

      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColors.surfaceContainerLowest,
        textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.onSurface),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // DARK THEME
  // ─────────────────────────────────────────────
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: const ColorScheme.dark(
        // Primary
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkOnPrimary,
        primaryContainer: AppColors.darkPrimaryContainer,
        onPrimaryContainer: AppColors.darkOnPrimaryContainer,

        // Secondary
        secondary: AppColors.darkSecondary,
        onSecondary: AppColors.darkOnSecondary,
        secondaryContainer: AppColors.darkSecondaryContainer,
        onSecondaryContainer: AppColors.darkOnSecondaryContainer,

        // Tertiary
        tertiary: AppColors.darkTertiary,
        onTertiary: AppColors.darkOnTertiary,
        tertiaryContainer: AppColors.darkTertiaryContainer,
        onTertiaryContainer: AppColors.darkOnTertiaryContainer,

        // Error
        error: AppColors.darkError,
        onError: AppColors.darkOnError,
        errorContainer: AppColors.darkErrorContainer,
        onErrorContainer: AppColors.darkOnErrorContainer,

        // Surface
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        surfaceVariant: AppColors.darkSurfaceVariant,
        onSurfaceVariant: AppColors.darkOnSurfaceVariant,

        // Outline
        outline: AppColors.darkOutline,
        outlineVariant: AppColors.darkOutlineVariant,

        // Inverse
        inverseSurface: AppColors.darkInverseSurface,
        onInverseSurface: AppColors.darkInverseOnSurface,
        inversePrimary: AppColors.darkInversePrimary,

        // Surface containers
        surfaceContainerLowest: AppColors.darkSurfaceContainerLowest,
        surfaceContainerLow: AppColors.darkSurfaceContainerLow,
        surfaceContainer: AppColors.darkSurfaceContainer,
        surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
        surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
      ),

      scaffoldBackgroundColor: AppColors.darkBackground,
      fontFamily: 'Inter',
      textTheme: _textTheme(AppColors.darkOnSurface, AppColors.darkOnSurfaceVariant, AppColors.darkOutline),

      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.darkOnSurface,
        titleTextStyle: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 20,
          height: 26 / 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
          color: AppColors.darkOnSurface,
        ),
        iconTheme: IconThemeData(color: AppColors.darkOnSurfaceVariant),
        actionsIconTheme: IconThemeData(color: AppColors.darkOnSurfaceVariant),
      ),

      inputDecorationTheme: _inputDecorationTheme(
        fill: AppColors.darkSurfaceContainerLowest,
        hint: AppColors.darkOutline,
        border: AppColors.darkOutlineVariant,
        focused: AppColors.darkPrimary,
        error: AppColors.darkError,
        label: AppColors.darkOnSurfaceVariant,
        floatingLabel: AppColors.darkPrimary,
      ),

      elevatedButtonTheme: _elevatedButtonTheme(AppColors.darkPrimary, AppColors.darkOnPrimary),
      filledButtonTheme: _filledButtonTheme(AppColors.darkPrimary, AppColors.darkOnPrimary),
      outlinedButtonTheme: _outlinedButtonTheme(AppColors.darkOutlineVariant, AppColors.darkOnSurface),
      textButtonTheme: _textButtonTheme(AppColors.darkPrimary),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkOnPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.darkPrimary,
        unselectedItemColor: AppColors.darkOnSurfaceVariant,
        selectedLabelStyle: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.darkOutlineVariant,
        thickness: 1,
        space: 1,
      ),

      snackBarTheme: SnackBarThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.darkInverseSurface,
        contentTextStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.darkInverseOnSurface,
        ),
        actionTextColor: AppColors.darkPrimary,
      ),

      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        backgroundColor: AppColors.darkSurfaceContainerLow,
        disabledColor: AppColors.darkSurfaceContainerHighest,
        selectedColor: AppColors.darkPrimaryContainer,
        labelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.darkOnSurfaceVariant),
        brightness: Brightness.dark,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedIconTheme: IconThemeData(color: AppColors.darkPrimary),
        unselectedIconTheme: IconThemeData(color: AppColors.darkOnSurfaceVariant),
        selectedLabelTextStyle: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.darkPrimary),
        unselectedLabelTextStyle: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.darkOnSurfaceVariant),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.darkPrimary,
        circularTrackColor: AppColors.darkSurfaceContainerHighest,
        linearTrackColor: AppColors.darkSurfaceContainerHighest,
      ),

      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColors.darkSurfaceContainerLowest,
        textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.darkOnSurface),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SHARED HELPERS
  // ─────────────────────────────────────────────

  static TextTheme _textTheme(Color onSurface, Color onSurfaceVariant, Color outline) {
    return TextTheme(
      displayLarge: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 28, height: 34 / 28, fontWeight: FontWeight.w700, letterSpacing: -0.02, color: onSurface),
      displayMedium: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 24, height: 30 / 24, fontWeight: FontWeight.w700, color: onSurface),
      displaySmall: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 20, height: 26 / 20, fontWeight: FontWeight.w600, letterSpacing: -0.01, color: onSurface),
      headlineLarge: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 28, height: 34 / 28, fontWeight: FontWeight.w700, letterSpacing: -0.02, color: onSurface),
      headlineMedium: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 20, height: 26 / 20, fontWeight: FontWeight.w600, letterSpacing: -0.01, color: onSurface),
      headlineSmall: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 24, height: 30 / 24, fontWeight: FontWeight.w700, color: onSurface),
      titleLarge: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 20, height: 26 / 20, fontWeight: FontWeight.w600, letterSpacing: -0.01, color: onSurface),
      titleMedium: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 17, height: 24 / 17, fontWeight: FontWeight.w600, color: onSurface),
      titleSmall: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 15, height: 20 / 15, fontWeight: FontWeight.w600, color: onSurface),
      bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 17, height: 24 / 17, fontWeight: FontWeight.w400, letterSpacing: -0.01, color: onSurface),
      bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 15, height: 20 / 15, fontWeight: FontWeight.w400, color: onSurface),
      bodySmall: TextStyle(fontFamily: 'Inter', fontSize: 13, height: 18 / 13, fontWeight: FontWeight.w400, color: onSurfaceVariant),
      labelLarge: TextStyle(fontFamily: 'Inter', fontSize: 13, height: 18 / 13, fontWeight: FontWeight.w600, letterSpacing: 0.05, color: onSurfaceVariant),
      labelMedium: TextStyle(fontFamily: 'Inter', fontSize: 12, height: 16 / 12, fontWeight: FontWeight.w500, color: onSurfaceVariant),
      labelSmall: TextStyle(fontFamily: 'Inter', fontSize: 11, height: 14 / 11, fontWeight: FontWeight.w500, color: outline),
    );
  }

  static InputDecorationTheme _inputDecorationTheme({
    required Color fill,
    required Color hint,
    required Color border,
    required Color focused,
    required Color error,
    required Color label,
    required Color floatingLabel,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fill,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: border, width: 1)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: border, width: 1)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: focused, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: error, width: 1)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: error, width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w400, color: hint),
      labelStyle: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.05, color: label),
      floatingLabelStyle: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.05, color: floatingLabel),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(Color bg, Color fg) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: const Size(double.infinity, 56),
        maximumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        textStyle: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.01),
        backgroundColor: bg,
        foregroundColor: fg,
      ),
    );
  }

  static FilledButtonThemeData _filledButtonTheme(Color bg, Color fg) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        textStyle: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.01),
        backgroundColor: bg,
        foregroundColor: fg,
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(Color border, Color fg) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        side: BorderSide(color: border),
        textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.05),
        foregroundColor: fg,
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(Color fg) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.05),
        foregroundColor: fg,
      ),
    );
  }
}