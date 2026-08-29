import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:movie_app/app.dart';

void main() {
  testWidgets('Movie app renders the main screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MovieApp()));

    expect(find.text('CineList'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
