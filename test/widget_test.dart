import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:insura/app/app.dart';
import 'package:insura/core/di/injector.dart';

void main() {
  setUp(setupInjector);

  tearDown(resetInjector);

  testWidgets('App starts on the login page', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('Insura'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'E-mail'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Senha'), findsOneWidget);
  });
}
