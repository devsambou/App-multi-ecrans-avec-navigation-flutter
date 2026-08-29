import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:movie_app/features/movies/screens/movie_list_screen.dart';
import 'package:movie_app/core/theme/app_theme.dart';

void main() {
  testWidgets('Movie list renders with search and filters',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          title: 'CineList',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: const MovieListScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byType(Card), findsWidgets);
    expect(find.byType(TextField), findsWidgets);
    expect(find.byType(ChoiceChip), findsWidgets);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
