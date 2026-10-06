import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insura/core/widgets/insura_app_bar.dart';
import 'package:insura/core/widgets/insura_logo.dart';

void main() {
  Future<void> pumpAppBar(WidgetTester tester, InsuraAppBar appBar) =>
      tester.pumpWidget(MaterialApp(home: Scaffold(appBar: appBar)));

  testWidgets('shows the logo when no title is given', (tester) async {
    await pumpAppBar(tester, const InsuraAppBar());

    expect(find.byType(InsuraLogo), findsOneWidget);
  });

  testWidgets('shows the page icon and title instead of the logo', (
    tester,
  ) async {
    await pumpAppBar(
      tester,
      const InsuraAppBar(icon: Icons.favorite_outline, title: 'Vida'),
    );

    expect(find.byType(InsuraLogo), findsNothing);
    expect(find.text('Vida'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_outline), findsOneWidget);
  });
}
