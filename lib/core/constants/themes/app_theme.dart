import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    //for the scaffold bg
    scaffoldBackgroundColor: const Color(0xFFEFEFF0),
    // for the obsidian icon
    canvasColor: const Color(0xFFEFEFF0),
    // for the Card
    cardColor: Colors.white,
    //! Color Schema
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF242628),
      brightness: Brightness.light,
      background: const Color(0xFFFFFFFF),
    ),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    // for the scaffold
    scaffoldBackgroundColor: const Color(0xFF171717),
    // for the obsidian icon
    canvasColor: const Color(0xFF202020),
    // for theCard
    cardColor: const Color(0xFF0D0D0D),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF242628),
      brightness: Brightness.dark,
      // background: const Color(0xFF0D0D0D),
      background: const Color(0xFF040404),
    ),
  );
}
