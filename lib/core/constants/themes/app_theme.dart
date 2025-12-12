import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // BRAND COLORS
  static const Color primaryDark = Color(0xFF042A2B);
  static const Color primaryDarker = Color(0xFF021416);
  static const Color gold = Color(0xFFB08B4F);
  static const Color surfaceDark = Color(0xFF0A0F10); // nice glossy dark
  static const Color cardDark = Color(0xFF0D1A1B); // subtle teal tint

  // -------------------------------
  // 🌞 LIGHT THEME
  // -------------------------------
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,
    cardColor: Colors.white,

    colorScheme: ColorScheme.fromSeed(
      seedColor: gold,
      brightness: Brightness.light,
      primary: primaryDark,
      secondary: gold,
      background: Colors.white,
      surface: Colors.white,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.black54),
    ),
  );

  // -------------------------------
  // 🌚 DARK THEME (StepUp STYLE)
  // -------------------------------
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // MAIN BACKGROUND (matches your onboarding & flows)
    scaffoldBackgroundColor: primaryDark,

    // Raw surfaces like BottomSheets / Drawers
    canvasColor: primaryDarker,

    // Cards / floating elements in dark mode
    cardColor: Colors.white.withOpacity(0.05),

    colorScheme: ColorScheme.fromSeed(
      seedColor: gold,
      brightness: Brightness.dark,
      primary: gold, // buttons, accents
      secondary: Colors.white70,
      background: primaryDarker, // deeper background
      surface: surfaceDark, // modal sheets, containers
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white70),
    ),
  );
}
