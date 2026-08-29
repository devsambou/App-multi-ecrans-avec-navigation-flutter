import 'package:flutter/material.dart';

/// Définit les deux thèmes de l'application (clair / sombre).
///
/// Les deux thèmes partagent la même "seedColor" (Material 3 génère
/// une palette cohérente à partir d'une seule couleur), ce qui évite
/// de dupliquer des dizaines de couleurs individuelles.
class AppTheme {
  AppTheme._();

  static const Color _seed = Color(0xFF6750A4); // violet cinéma

  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(centerTitle: false),
    cardTheme: const CardThemeData(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(centerTitle: false),
    cardTheme: const CardThemeData(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
    ),
  );
}
