import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

/// Widget racine de l'application.
///
/// ConsumerWidget (Riverpod) au lieu de StatefulWidget : on écoute
/// `themeModeProvider` sans avoir à gérer manuellement un `setState`
/// ni à faire remonter l'état via des callbacks entre écrans.
class MovieApp extends ConsumerWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'CineList',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      // MaterialApp.router délègue toute la navigation à GoRouter
      // (routerConfig), au lieu du système de routes classique Navigator 1.0.
      routerConfig: appRouter,
    );
  }
}
