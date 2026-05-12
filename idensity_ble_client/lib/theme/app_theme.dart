// lib/theme/app_theme.dart
// Drop this file into idensity_ble_client/lib/theme/app_theme.dart
// and replace the ThemeData in main.dart:
//
//   import 'package:idensity_ble_client/theme/app_theme.dart';
//   ...
//   MaterialApp.router(
//     theme: AppTheme.light,
//     ...
//   )
//
// Палитра — Konvels / RTK (light), извлечена из Figma-референса.

import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const Color primary       = Color(0xFF28BCBA); // Konvels teal
  static const Color primaryDark   = Color(0xFF1FA9A7);
  static const Color primaryLight  = Color(0xFFB8EDEC);
  static const Color onPrimary     = Color(0xFFFFFFFF);

  // Neutrals
  static const Color background    = Color(0xFFFAFAFA);
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color surfaceAlt    = Color(0xFFF4F4F4); // table header / hover
  static const Color outline       = Color(0xFFE0E0E0);
  static const Color outlineSubtle = Color(0xFFEDEDED);
  static const Color chipBg        = Color(0xFFE0E0E0);

  // Text
  static const Color textPrimary   = Color(0xFF202020);
  static const Color textSecondary = Color(0xFF5C5C5C);
  static const Color textMuted     = Color(0xFF8A8A8A);

  // Semantic
  static const Color error         = Color(0xFFD32F2F);
  static const Color warning       = Color(0xFFF59E0B);
  static const Color success       = Color(0xFF26A269);
}

class AppTheme {
  static ThemeData get light {
    final scheme = const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: Color(0xFF002020),
      secondary: AppColors.primaryDark,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.primaryLight,
      onSecondaryContainer: Color(0xFF002020),
      tertiary: AppColors.primary,
      onTertiary: Colors.white,
      tertiaryContainer: AppColors.primaryLight,
      onTertiaryContainer: Color(0xFF002020),
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceAlt,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineSubtle,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Color(0xFF2F3131),
      onInverseSurface: Color(0xFFF1F1F1),
      inversePrimary: Color(0xFF83D5C6),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      // ── AppBar ─────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: AppColors.primary,
        toolbarHeight: 60,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.onPrimary, size: 40),
        actionsIconTheme: IconThemeData(color: AppColors.onPrimary, size: 40),
        titleTextStyle: TextStyle(
          color: AppColors.onPrimary,
          fontSize: 19,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
      ),

      // ── Drawer ─────────────────────────────────────────────
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
      ),

      // ── List tiles (drawer items, params rows) ─────────────
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
        selectedTileColor: Color(0x1428BCBA), // primary @ 8% alpha
        selectedColor: AppColors.primary,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        minVerticalPadding: 12,
        dense: false,
      ),

      // ── Cards ──────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.outline, width: 1),
        ),
      ),

      // ── Buttons ────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          minimumSize: const Size(0, 48),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(0, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(0, 48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(AppColors.textSecondary),
        ),
      ),

      // ── Inputs ─────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        hintStyle: const TextStyle(color: AppColors.textMuted),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        floatingLabelStyle: const TextStyle(color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),

      // ── Dividers ───────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineSubtle,
        thickness: 1,
        space: 1,
      ),

      // ── Chips ──────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.chipBg,
        labelStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide.none,
      ),

      // ── Dialogs / SnackBars ────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF2F3131),
        contentTextStyle: TextStyle(color: Colors.white, fontSize: 14),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Progress / Switch / Checkbox ───────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.primary : Colors.white,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.primary.withValues(alpha: 0.4)
              : AppColors.outline,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.primary : Colors.transparent,
        ),
        side: const BorderSide(color: AppColors.outline, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.primary : AppColors.outline,
        ),
      ),

      // ── Typography ─────────────────────────────────────────
      textTheme: const TextTheme(
        displayLarge:  TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        displayMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        displaySmall:  TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        headlineLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        headlineMedium:TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        headlineSmall: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        titleLarge:    TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w500),
        titleMedium:   TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall:    TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge:     TextStyle(color: AppColors.textPrimary, fontSize: 16),
        bodyMedium:    TextStyle(color: AppColors.textPrimary, fontSize: 14),
        bodySmall:     TextStyle(color: AppColors.textSecondary, fontSize: 12),
        labelLarge:    TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium:   TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall:    TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }
}
