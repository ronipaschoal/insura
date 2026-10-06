import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insura/core/responsive/device_preview_shell.dart';

void main() {
  Future<void> pumpShell(WidgetTester tester, Size size) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => DevicePreviewShell(child: child!),
        home: Builder(
          builder: (context) => Scaffold(
            body: Text('APP:${MediaQuery.sizeOf(context).width.toInt()}'),
          ),
        ),
      ),
    );
  }

  testWidgets('small screens render the app without the banner', (
    tester,
  ) async {
    await pumpShell(tester, const Size(400, 800));

    expect(find.text('APP:400'), findsOneWidget);
    expect(find.text('Visualizar como'), findsNothing);
  });

  testWidgets('large screens show the banner, starting on the web layout', (
    tester,
  ) async {
    await pumpShell(tester, const Size(1280, 900));

    expect(find.text('Visualizar como'), findsOneWidget);
    expect(find.text('APP:1280'), findsOneWidget);
  });

  testWidgets('the Mobile toggle renders the app at phone size and back', (
    tester,
  ) async {
    await pumpShell(tester, const Size(1280, 900));

    await tester.tap(find.text('Mobile'));
    await tester.pumpAndSettle();
    expect(
      find.text('APP:${DevicePreviewShell.phoneScreenSize.width.toInt()}'),
      findsOneWidget,
    );

    await tester.tap(find.text('Web'));
    await tester.pumpAndSettle();
    expect(find.text('APP:1280'), findsOneWidget);
  });

  testWidgets('switching modes keeps the app state', (tester) async {
    tester.view
      ..physicalSize = const Size(1280, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => DevicePreviewShell(child: child!),
        home: const Scaffold(body: TextField()),
      ),
    );
    await tester.enterText(find.byType(TextField), 'kept');

    await tester.tap(find.text('Mobile'));
    await tester.pumpAndSettle();

    expect(find.text('kept'), findsOneWidget);
  });
}
