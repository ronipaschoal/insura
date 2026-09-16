import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insura/core/responsive/responsive_scaffold.dart';

void main() {
  const destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Início',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: 'Configurações',
    ),
  ];

  Widget buildScaffold({
    ValueChanged<int>? onDestinationSelected,
    VoidCallback? onLogout,
  }) {
    return MaterialApp(
      home: ResponsiveScaffold(
        destinations: destinations,
        userName: 'Ana',
        onDestinationSelected: onDestinationSelected,
        onLogout: onLogout,
        body: const Center(child: Text('BODY')),
      ),
    );
  }

  Future<void> setViewSize(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  group('mobile width', () {
    testWidgets('renders the app bar but keeps destinations in a closed '
        'drawer', (tester) async {
      await setViewSize(tester, const Size(390, 844));
      await tester.pumpWidget(buildScaffold());

      expect(find.text('INSURA'), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.text('BODY'), findsOneWidget);
      expect(find.text('Início'), findsNothing);
    });

    testWidgets('opening the menu reveals the destinations and user name', (
      tester,
    ) async {
      await setViewSize(tester, const Size(390, 844));
      await tester.pumpWidget(buildScaffold());

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.text('ANA'), findsOneWidget);
      expect(find.text('Início'), findsOneWidget);
      expect(find.text('Configurações'), findsOneWidget);
    });

    testWidgets('selecting a destination closes the drawer and forwards '
        'the index', (tester) async {
      await setViewSize(tester, const Size(390, 844));
      int? selected;
      await tester.pumpWidget(
        buildScaffold(onDestinationSelected: (index) => selected = index),
      );

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Configurações'));
      await tester.pumpAndSettle();

      expect(selected, 1);
      expect(find.text('Configurações'), findsNothing);
    });

    testWidgets('tapping Sair closes the drawer and calls onLogout', (
      tester,
    ) async {
      await setViewSize(tester, const Size(390, 844));
      var loggedOut = false;
      await tester.pumpWidget(buildScaffold(onLogout: () => loggedOut = true));

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sair'));
      await tester.pumpAndSettle();

      expect(loggedOut, isTrue);
      expect(find.text('Sair'), findsNothing);
    });
  });

  group('desktop width', () {
    testWidgets('renders the side menu and body without opening a drawer', (
      tester,
    ) async {
      await setViewSize(tester, const Size(1200, 800));
      await tester.pumpWidget(buildScaffold());

      expect(find.text('ANA'), findsOneWidget);
      expect(find.text('Início'), findsOneWidget);
      expect(find.text('Configurações'), findsOneWidget);
      expect(find.text('BODY'), findsOneWidget);
    });

    testWidgets('the menu button collapses and re-expands the side menu', (
      tester,
    ) async {
      await setViewSize(tester, const Size(1200, 800));
      await tester.pumpWidget(buildScaffold());
      expect(find.text('Início'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      expect(find.text('Início'), findsNothing);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      expect(find.text('Início'), findsOneWidget);
    });

    testWidgets('selecting a destination forwards its index directly', (
      tester,
    ) async {
      await setViewSize(tester, const Size(1200, 800));
      int? selected;
      await tester.pumpWidget(
        buildScaffold(onDestinationSelected: (index) => selected = index),
      );

      await tester.tap(find.text('Configurações'));

      expect(selected, 1);
    });
  });
}
