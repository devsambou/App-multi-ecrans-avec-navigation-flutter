import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:movie_app/features/movies/screens/movie_form_screen.dart';
import 'package:movie_app/core/theme/app_theme.dart';

void main() {
  testWidgets('Movie form renders with all fields and save button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          title: 'CineList',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: const MovieFormScreen(),
        ),
      ),
    );

    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(TextFormField), findsWidgets);
    expect(find.byIcon(Icons.save), findsOneWidget);
  });

  testWidgets('Movie form shows validation error for empty title',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          title: 'CineList',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: const MovieFormScreen(),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Le titre doit contenir au moins 2 caractères'),
        findsOneWidget);
  });
}
