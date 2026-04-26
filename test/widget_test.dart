import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:artificial_flash/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ArtificialFlashApp()));
    await tester.pumpAndSettle();

    expect(find.text('ArtificialFlash'), findsWidgets);
  });
}
