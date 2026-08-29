import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// StateNotifier qui gère le ThemeMode courant ET sa persistance.
///
/// Pourquoi un StateNotifier plutôt qu'un simple StateProvider ?
/// Parce qu'on a besoin d'une logique (charger/sauvegarder dans
/// SharedPreferences) autour du changement d'état, pas juste
/// stocker une valeur brute.
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadFromPrefs();
  }

  static const _prefsKey = 'theme_mode';

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    switch (saved) {
      case 'light':
        state = ThemeMode.light;
      case 'dark':
        state = ThemeMode.dark;
      default:
        state = ThemeMode.system;
    }
  }

  Future<void> toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, next == ThemeMode.dark ? 'dark' : 'light');
  }
}

/// Provider exposé à toute l'app. Un seul point d'accès au thème :
/// n'importe quel écran peut faire `ref.watch(themeModeProvider)`.
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});
