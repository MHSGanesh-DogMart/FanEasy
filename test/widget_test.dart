import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:faneasy/app/app.dart';

void main() {
  testWidgets('App boots without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const FanEasyApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
