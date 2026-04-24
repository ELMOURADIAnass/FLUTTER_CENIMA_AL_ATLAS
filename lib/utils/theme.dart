import 'package:flutter/material.dart';

// Premium Cinema Dark Theme with Cinema Yellow Accent
class AppColors {
  // ============================================
  // BACKGROUND & SURFACE COLORS - DARK MODE
  // ============================================
  // Pure black - main background for cinema aesthetic
  static const Color background = Color(0xFF000000);

  // Dark gray - elevated surfaces and cards
  static const Color surface = Color(0xFF1A1A1A);

  // Slightly lighter dark gray - alternative surface
  static const Color surfaceLight = Color(0xFF2A2A2A);

  // ============================================
  // PRIMARY ACCENT - CINEMA YELLOW
  // ============================================
  // Bright cinema yellow - primary accent for actions & highlights
  static const Color primary = Color(0xFFF4C518);

  // Darker variant of yellow for pressed states
  static const Color primaryDark = Color(0xFFD4A517);

  // ============================================
  // TEXT COLORS - WHITE ON BLACK
  // ============================================
  // Primary text - pure white for maximum readability
  static const Color textPrimary = Color(0xFFFFFFFF);

  // Secondary text - light gray for less important info
  static const Color textSecondary = Color(0xFFA1A1A1);

  // Muted/tertiary text - darker gray for very secondary info
  static const Color textMuted = Color(0xFF767676);

  // ============================================
  // BORDER & DIVIDER COLORS
  // ============================================
  // Subtle borders for dark theme
  static const Color border = Color(0xFF333333);
  static const Color divider = Color(0xFF333333);

  // ============================================
  // TABLE-SPECIFIC COLORS
  // ============================================
  // Table header background
  static const Color tableHeaderBackground = Color(0xFF1A1A1A);

  // Table header text - white for contrast
  static const Color tableHeaderText = Color(0xFFFFFFFF);

  // Table body background
  static const Color tableBackground = Color(0xFF0F0F0F);

  // Table divider/border
  static const Color tableDivider = Color(0xFF333333);

  // Table row hover state - subtle yellow highlight
  static const Color tableRowHover = Color(0x12F4C518); // rgba(244, 197, 24, 0.07)

  // ============================================
  // SEMANTIC COLORS
  // ============================================
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFBBF24);

  // ============================================
  // LEGACY SUPPORT - REDIRECT TO NEW COLORS
  // ============================================
  static const Color secondary = primary;
  static const Color secondaryDark = primaryDark;
  static const Color accent = primary;

  // ============================================
  // OVERLAY & TRANSPARENCY COLORS
  // ============================================
  static const Color darkOverlay = Color(0x99000000);
  static const Color yellowOverlay = Color(0x1AF4C518);

  // ============================================
  // OPACITY CONSTANTS (for semantic use)
  // ============================================
  static const double opacityDisabled = 0.38;
  static const double opacityHover = 0.12;
  static const double opacityFocus = 0.16;
  static const double opacityActive = 0.20;
  static const double opacitySelected = 0.20;

  // ============================================
  // GRADIENT DEFINITIONS
  // ============================================
  // Premium gradient with yellow accent
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dark hero gradient with yellow tint
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0x00000000), Color(0xE6000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Yellow accent gradient for premium elements
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF4C518), Color(0xFFD4A517)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// Premium Typography with clear hierarchy
class AppTypography {
  // Headings - large and bold with cinematic presence
  static const TextStyle h1 = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Body text with improved readability on dark backgrounds
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.6,
    letterSpacing: 0.2,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
    letterSpacing: 0.1,
  );

  // Labels and captions - subtle but readable
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
    height: 1.4,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.background,
    letterSpacing: 0.8,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
    letterSpacing: 1.5,
    height: 1.4,
  );

  // Premium accent text for important highlights
  static const TextStyle accentHighlight = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 0.5,
  );
}

// Premium Dark Theme Configuration
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.background,
        onSecondary: AppColors.background,
        onSurface: AppColors.textPrimary,
        onError: Color(0xFFFFFFFF),
      ),
      textTheme: const TextTheme(
        displayLarge: AppTypography.h1,
        displayMedium: AppTypography.h2,
        displaySmall: AppTypography.h3,
        headlineMedium: AppTypography.h4,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.body,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.button,
        labelSmall: AppTypography.caption,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          elevation: 4,
          shadowColor: AppColors.primary.withValues(alpha: 0.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.button,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return AppColors.primaryDark.withValues(alpha: 0.15);
            }
            if (states.contains(WidgetState.pressed)) {
              return Colors.black.withValues(alpha: 0.2);
            }
            return null;
          }),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return AppColors.primary.withValues(alpha: 0.08);
            }
            return null;
          }),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: AppTypography.body.copyWith(color: AppColors.textSecondary),
        labelStyle: AppTypography.body.copyWith(color: AppColors.textSecondary),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 12,
        centerTitle: false,
        titleTextStyle: AppTypography.h4.copyWith(color: AppColors.textPrimary),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(AppColors.tableHeaderBackground),
        dataRowColor: WidgetStateProperty.all(AppColors.tableBackground),
        headingRowHeight: 56,
        dataRowMinHeight: 56,
        dataRowMaxHeight: 56,
        dividerThickness: 1,
        headingTextStyle: AppTypography.button.copyWith(color: AppColors.primary),
        dataTextStyle: AppTypography.body,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // Floating Action Button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 8,
        disabledElevation: 0,
        highlightElevation: 12,
      ),
      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        side: const BorderSide(color: AppColors.primary, width: 2),
      ),
      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
      ),
    );
  }
}
