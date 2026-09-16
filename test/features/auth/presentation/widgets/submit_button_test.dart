import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insura/features/auth/presentation/widgets/submit_button.dart';

void main() {
  testWidgets('shows an arrow icon and forwards taps when not loading', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: SubmitButton(isLoading: false, onPressed: () => tapped = true),
      ),
    );

    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byType(SubmitButton));

    expect(tapped, isTrue);
  });

  testWidgets('shows a progress indicator instead of the arrow when loading', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: SubmitButton(isLoading: true)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsNothing);
  });

  testWidgets('does not throw when tapped with no onPressed callback', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: SubmitButton(isLoading: false)),
    );

    await tester.tap(find.byType(SubmitButton));

    expect(tester.takeException(), isNull);
  });
}
