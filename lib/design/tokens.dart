import 'package:flutter/material.dart';

class SydneyColors {
  const SydneyColors._();

  static const ink = Color(0xFF17201C);
  static const mutedInk = Color(0xFF66736D);
  static const subtleInk = Color(0xFF8B9691);
  static const surface = Color(0xFFFCFCFA);
  static const surfaceWarm = Color(0xFFF6F2EA);
  static const surfaceRaised = Color(0xFFFFFFFF);
  static const line = Color(0xFFE7E4DD);
  static const primary = Color(0xFF1D7A5C);
  static const primarySoft = Color(0xFFE4F3EC);
  static const agentBubble = Color(0xFFFFFFFF);
  static const userBubble = Color(0xFFDDF4E8);
  static const systemBubble = Color(0xFFF1EEE8);
  static const danger = Color(0xFFC84A3D);
  static const dangerSoft = Color(0xFFFCE9E6);
  static const warning = Color(0xFFC07A22);
  static const warningSoft = Color(0xFFFFF3D8);
  static const info = Color(0xFF356C91);
  static const infoSoft = Color(0xFFE5F1F7);
}

class SydneySpacing {
  const SydneySpacing._();

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double page = 20;
}

class SydneyRadius {
  const SydneyRadius._();

  static const double xs = 6;
  static const double sm = 8;
  static const double md = 14;
  static const double lg = 20;
  static const double full = 999;

  static const BorderRadius bubbleAgent = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
    bottomLeft: Radius.circular(xs),
    bottomRight: Radius.circular(lg),
  );

  static const BorderRadius bubbleUser = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
    bottomLeft: Radius.circular(lg),
    bottomRight: Radius.circular(xs),
  );
}

class SydneyTypography {
  const SydneyTypography._();

  static const fontFamily = 'Roboto';

  static TextTheme get textTheme => const TextTheme(
    displaySmall: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      height: 1.12,
      color: SydneyColors.ink,
    ),
    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      height: 1.2,
      color: SydneyColors.ink,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      height: 1.25,
      color: SydneyColors.ink,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 1.28,
      color: SydneyColors.ink,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.45,
      color: SydneyColors.ink,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: SydneyColors.ink,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.35,
      color: SydneyColors.mutedInk,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      height: 1.2,
      color: SydneyColors.ink,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      height: 1.2,
      color: SydneyColors.mutedInk,
    ),
  );
}

class SydneyTheme {
  const SydneyTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: SydneyColors.primary,
      brightness: Brightness.light,
      primary: SydneyColors.primary,
      surface: SydneyColors.surface,
      error: SydneyColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: SydneyTypography.fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: SydneyColors.surface,
      textTheme: SydneyTypography.textTheme,
      dividerColor: SydneyColors.line,
      appBarTheme: const AppBarTheme(
        backgroundColor: SydneyColors.surface,
        foregroundColor: SydneyColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: SydneyColors.ink,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SydneyColors.surfaceRaised,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SydneyRadius.md),
          borderSide: const BorderSide(color: SydneyColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SydneyRadius.md),
          borderSide: const BorderSide(color: SydneyColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SydneyRadius.md),
          borderSide: const BorderSide(color: SydneyColors.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SydneyRadius.md),
          borderSide: const BorderSide(color: SydneyColors.danger),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SydneySpacing.lg,
          vertical: SydneySpacing.md,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: SydneyColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SydneyRadius.md),
          ),
          textStyle: SydneyTypography.textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SydneyColors.ink,
          side: const BorderSide(color: SydneyColors.line),
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SydneyRadius.md),
          ),
          textStyle: SydneyTypography.textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: SydneyColors.primary,
          textStyle: SydneyTypography.textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: SydneyColors.ink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SydneyRadius.sm),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: SydneyColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SydneyRadius.lg),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: SydneyColors.surfaceRaised,
        selectedColor: SydneyColors.primarySoft,
        disabledColor: SydneyColors.surfaceWarm,
        labelStyle: SydneyTypography.textTheme.bodySmall,
        side: const BorderSide(color: SydneyColors.line),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SydneyRadius.full),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: SydneyColors.ink,
        contentTextStyle: SydneyTypography.textTheme.bodyMedium?.copyWith(
          color: Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SydneyRadius.sm),
        ),
      ),
    );
  }
}
