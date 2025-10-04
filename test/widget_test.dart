import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sih2025/main.dart';

void main() {
  testWidgets('TempleApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TempleApp());

    // Verify that the app shows the temple title in the AppBar.
    expect(find.text('Dwarka Temple'), findsOneWidget);

    // You can also check if the bottom navigation bar exists.
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
