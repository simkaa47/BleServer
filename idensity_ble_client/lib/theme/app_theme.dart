// lib/theme/app_theme.dart
// Drop into idensity_ble_client/lib/theme/app_theme.dart.
// В main.dart:
//
//   import 'package:idensity_ble_client/theme/app_theme.dart';
//   ...
//   MaterialApp.router(
//     theme: AppTheme.light,
//     darkTheme: AppTheme.dark,
//     themeMode: ThemeMode.system,   // или .light / .dark
//     routerConfig: router,
//   )
//
// Палитра — Konvels / RTK.

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// Цветовые токены
// ─────────────────────────────────────────────────────────────
class AppColorTokens {
  const AppColorTokens({
    required this.brightness,
    required this.primary,
    required this.primaryDark,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.onPrimary,
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.outline,
    required this.outlineSubtle,
    required this.chipBg,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.error,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.warning,
    required this.success,
    required this.snackBarBg,
  });

  final Brightness brightness;
  final Color primary;
  final Color primaryDark;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color onPrimary;
  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color outline;
  final Color outlineSubtle;
  final Color chipBg;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color error;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color warning;
  final Color success;
  final Color snackBarBg;

  static const AppColorTokens light = AppColorTokens(
    brightness:          Brightness.light,
    primary:             Color(0xFF28BCBA),
    primaryDark:         Color(0xFF1FA9A7),
    primaryContainer:    Color(0xFFB8EDEC),
    onPrimaryContainer:  Color(0xFF002020),
    onPrimary:           Color(0xFFFFFFFF),
    background:          Color(0xFFFAFAFA),
    surface:             Color(0xFFFFFFFF),
    surfaceAlt:          Color(0xFFF4F4F4),
    outline:             Color(0xFFE0E0E0),
    outlineSubtle:       Color(0xFFEDEDED),
    chipBg:              Color(0xFFE0E0E0),
    textPrimary:         Color(0xFF202020),
    textSecondary:       Color(0xFF5C5C5C),
    textMuted:           Color(0xFF8A8A8A),
    error:               Color(0xFFD32F2F),
    errorContainer:      Color(0xFFFFDAD6),
    onErrorContainer:    Color(0xFF410002),
    warning:             Color(0xFFF59E0B),
    success:             Color(0xFF26A269),
    snackBarBg:          Color(0xFF2F3131),
  );

  static const AppColorTokens dark = AppColorTokens(
    brightness:          Brightness.dark,
    primary:             Color(0xFF2DD4D2),
    primaryDark:         Color(0xFF28BCBA),
    primaryContainer:    Color(0xFF0F3938),
    onPrimaryContainer:  Color(0xFFB8EDEC),
    onPrimary:           Color(0xFFFFFFFF),
    background:          Color(0xFF121414),
    surface:             Color(0xFF1A1D1D),
    surfaceAlt:          Color(0xFF252A2A),
    outline:             Color(0xFF3A4040),
    outlineSubtle:       Color(0xFF2A3030),
    chipBg:              Color(0xFF2F3535),
    textPrimary:         Color(0xFFE6E8E8),
    textSecondary:       Color(0xFFB0B6B6),
    textMuted:           Color(0xFF7A8080),
    error:               Color(0xFFFF6B6B),
    errorContainer:      Color(0xFF441010),
    onErrorContainer:    Color(0xFFFFDAD6),
    warning:             Color(0xFFFBBF24),
    success:             Color(0xFF4ADE80),
    snackBarBg:          Color(0xFFE6E8E8),
  );
}

// ─────────────────────────────────────────────────────────────
// Удобный доступ для виджетов:
//   Theme.of(context).extension<AppExtras>()?.warning
//   Theme.of(context).extension<AppExtras>()?.success
// (warning/success — не входят в M3 ColorScheme, поэтому через extension)
// ─────────────────────────────────────────────────────────────
class AppExtras extends ThemeExtension<AppExtras> {
  const AppExtras({
    required this.warning,
    required this.success,
    required this.textMuted,
    required this.surfaceAlt,
  });
  final Color warning;
  final Color success;
  final Color textMuted;
  final Color surfaceAlt;

  @override
  AppExtras copyWith({Color? warning, Color? success, Color? textMuted, Color? surfaceAlt}) =>
      AppExtras(
        warning: warning ?? this.warning,
        success: success ?? this.success,
        textMuted: textMuted ?? this.textMuted,
        surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      );

  @override
  AppExtras lerp(ThemeExtension<AppExtras>? other, double t) {
    if (other is! AppExtras) return this;
    return AppExtras(
      warning:    Color.lerp(warning,    other.warning,    t)!,
      success:    Color.lerp(success,    other.success,    t)!,
      textMuted:  Color.lerp(textMuted,  other.textMuted,  t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Бэккомпат: AppColors указывает на light-токены, чтобы код
// который раньше писал AppColors.primary продолжал работать.
// Новые виджеты лучше брать через Theme.of(context).colorScheme / AppExtras.
// ─────────────────────────────────────────────────────────────
class AppColors {
  static const Color primary       = Color(0xFF28BCBA);
  static const Color primaryDark   = Color(0xFF1FA9A7);
  static const Color primaryLight  = Color(0xFFB8EDEC);
  static const Color onPrimary     = Color(0xFFFFFFFF);
  static const Color background    = Color(0xFFFAFAFA);
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color surfaceAlt    = Color(0xFFF4F4F4);
  static const Color outline       = Color(0xFFE0E0E0);
  static const Color outlineSubtle = Color(0xFFEDEDED);
  static const Color chipBg        = Color(0xFFE0E0E0);
  static const Color textPrimary   = Color(0xFF202020);
  static const Color textSecondary = Color(0xFF5C5C5C);
  static const Color textMuted     = Color(0xFF8A8A8A);
  static const Color error         = Color(0xFFD32F2F);
  static const Color warning       = Color(0xFFF59E0B);
  static const Color success       = Color(0xFF26A269);
}

// ─────────────────────────────────────────────────────────────
// AppTheme
// ─────────────────────────────────────────────────────────────
class AppTheme {
  static ThemeData get light => _build(AppColorTokens.light);
  static ThemeData get dark  => _build(AppColorTokens.dark);

  static ThemeData _build(AppColorTokens t) {
    final isDark = t.brightness == Brightness.dark;

    final scheme = ColorScheme(
      brightness: t.brightness,
      primary: t.primary,
      onPrimary: t.onPrimary,
      primaryContainer: t.primaryContainer,
      onPrimaryContainer: t.onPrimaryContainer,
      secondary: t.primaryDark,
      onSecondary: t.onPrimary,
      secondaryContainer: t.primaryContainer,
      onSecondaryContainer: t.onPrimaryContainer,
      tertiary: t.primary,
      onTertiary: t.onPrimary,
      tertiaryContainer: t.primaryContainer,
      onTertiaryContainer: t.onPrimaryContainer,
      error: t.error,
      onError: t.onPrimary,
      errorContainer: t.errorContainer,
      onErrorContainer: t.onErrorContainer,
      surface: t.surface,
      onSurface: t.textPrimary,
      surfaceContainerHighest: t.surfaceAlt,
      onSurfaceVariant: t.textSecondary,
      outline: t.outline,
      outlineVariant: t.outlineSubtle,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface:   isDark ? const Color(0xFFE6E8E8) : const Color(0xFF2F3131),
      onInverseSurface: isDark ? const Color(0xFF1A1D1D) : const Color(0xFFF1F1F1),
      inversePrimary:   isDark ? const Color(0xFF28BCBA) : const Color(0xFF83D5C6),
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: t.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: t.background,
      fontFamily: 'Roboto',
      extensions: [
        AppExtras(
          warning: t.warning,
          success: t.success,
          textMuted: t.textMuted,
          surfaceAlt: t.surfaceAlt,
        ),
      ],
    );

    return base.copyWith(
      // ── AppBar ─────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: t.primary,
        foregroundColor: t.onPrimary,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: t.primary,
        toolbarHeight: 60,
        centerTitle: false,
        iconTheme: IconThemeData(color: t.onPrimary, size: 28),
        actionsIconTheme: IconThemeData(color: t.onPrimary, size: 28),
        titleTextStyle: TextStyle(
          color: t.onPrimary,
          fontSize: 19,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
      ),

      // ── Drawer ─────────────────────────────────────────────
      drawerTheme: DrawerThemeData(
        backgroundColor: t.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shape: const RoundedRectangleBorder(),
      ),

      // ── ListTile (drawer items, settings rows) ─────────────
      listTileTheme: ListTileThemeData(
        iconColor: t.textSecondary,
        textColor: t.textPrimary,
        selectedTileColor: t.primary.withValues(alpha: 0.15),
        selectedColor: t.textPrimary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        minVerticalPadding: 12,
        dense: false,
      ),

      // ── Cards ──────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: t.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: t.outline, width: 1),
        ),
      ),

      // ── Buttons ────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: t.primary,
          foregroundColor: t.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5,
          ),
          minimumSize: const Size(0, 48),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: t.primary,
          foregroundColor: t.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(0, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: t.primary,
          side: BorderSide(color: t.primary, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(0, 48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: t.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(t.textSecondary),
        ),
      ),

      // ── Inputs ─────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: t.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        hintStyle: TextStyle(color: t.textMuted),
        labelStyle: TextStyle(color: t.textSecondary),
        floatingLabelStyle: TextStyle(color: t.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: t.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: t.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: t.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: t.error),
        ),
      ),

      // ── Dividers ───────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: t.outlineSubtle,
        thickness: 1,
        space: 1,
      ),

      // ── Chips ──────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: t.chipBg,
        labelStyle: TextStyle(color: t.textPrimary, fontSize: 13),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide.none,
      ),

      // ── Dialogs / SnackBars ────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: t.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: t.snackBarBg,
        contentTextStyle: TextStyle(
          color: isDark ? const Color(0xFF1A1D1D) : Colors.white,
          fontSize: 14,
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Progress / Switch / Checkbox / Radio ───────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(color: t.primary),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.primary : t.surface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? t.primary.withValues(alpha: 0.4)
              : t.outline,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.primary : Colors.transparent,
        ),
        side: BorderSide(color: t.outline, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.primary : t.outline,
        ),
      ),

      // ── Typography ─────────────────────────────────────────
      textTheme: TextTheme(
        displayLarge:  TextStyle(color: t.textPrimary, fontWeight: FontWeight.w500),
        displayMedium: TextStyle(color: t.textPrimary, fontWeight: FontWeight.w500),
        displaySmall:  TextStyle(color: t.textPrimary, fontWeight: FontWeight.w500),
        headlineLarge: TextStyle(color: t.textPrimary, fontWeight: FontWeight.w500),
        headlineMedium:TextStyle(color: t.textPrimary, fontWeight: FontWeight.w500),
        headlineSmall: TextStyle(color: t.textPrimary, fontWeight: FontWeight.w500),
        titleLarge:    TextStyle(color: t.textPrimary, fontSize: 20, fontWeight: FontWeight.w500),
        titleMedium:   TextStyle(color: t.textPrimary, fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall:    TextStyle(color: t.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge:     TextStyle(color: t.textPrimary, fontSize: 16),
        bodyMedium:    TextStyle(color: t.textPrimary, fontSize: 14),
        bodySmall:     TextStyle(color: t.textSecondary, fontSize: 12),
        labelLarge:    TextStyle(color: t.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium:   TextStyle(color: t.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall:    TextStyle(color: t.textMuted, fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }
}
