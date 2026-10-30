
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nicole_project/app.dart';

void main() {
  testWidgets('TindaSmart app loads successfully', (WidgetTester tester) async {
    // Build the TindaSmart application.
    await tester.pumpWidget(const MyApp());

    // Verify that the MaterialApp is displayed.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
