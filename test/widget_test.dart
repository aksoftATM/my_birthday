// Basic smoke test: verifies the app boots and renders without crashing.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mybirthday_app/main.dart';
import 'package:mybirthday_app/shared/data/user_profile_repository.dart';

void main() {
  testWidgets('BirthDayApp builds and shows a MaterialApp', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const BirthDayApp(),
      ),
    );
    // The app has infinitely-repeating animations (cosmic background) and a
    // periodic countdown timer, so pumpAndSettle would never settle.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
