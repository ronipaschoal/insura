import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insura/core/responsive/app_side_menu.dart';

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

  Widget buildMenu({
    String userName = 'Ana',
    int selectedIndex = 0,
    bool expanded = true,
    ValueChanged<int>? onDestinationSelected,
    VoidCallback? onLogout,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AppSideMenu(
          userName: userName,
          destinations: destinations,
          selectedIndex: selectedIndex,
          expanded: expanded,
          onDestinationSelected: onDestinationSelected,
          onLogout: onLogout,
        ),
      ),
    );
  }

  testWidgets('renders the greeting, user name and destinations when '
      'expanded', (tester) async {
    await tester.pumpWidget(buildMenu(userName: 'Ana'));

    expect(find.text('Olá!'), findsOneWidget);
    expect(find.text('ANA'), findsOneWidget);
    expect(find.text('Minha conta'), findsOneWidget);
    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Configurações'), findsOneWidget);
  });

  testWidgets('falls back to "Usuário" when userName is empty', (tester) async {
    await tester.pumpWidget(buildMenu(userName: ''));

    expect(find.text('USUÁRIO'), findsOneWidget);
  });

  testWidgets('shows the selected destination\'s filled icon', (tester) async {
    await tester.pumpWidget(buildMenu(selectedIndex: 1));

    expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsNothing);
  });

  testWidgets('hides labels and the header name when collapsed', (
    tester,
  ) async {
    await tester.pumpWidget(buildMenu(expanded: false));

    expect(find.text('Olá!'), findsNothing);
    expect(find.text('ANA'), findsNothing);
    expect(find.text('Início'), findsNothing);
    expect(find.text('Configurações'), findsNothing);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
  });

  testWidgets('tapping a destination invokes onDestinationSelected with '
      'its index', (tester) async {
    int? selected;
    await tester.pumpWidget(
      buildMenu(onDestinationSelected: (index) => selected = index),
    );

    await tester.tap(find.text('Configurações'));

    expect(selected, 1);
  });

  testWidgets('tapping Sair invokes onLogout when expanded', (tester) async {
    var loggedOut = false;
    await tester.pumpWidget(buildMenu(onLogout: () => loggedOut = true));

    await tester.tap(find.text('Sair'));

    expect(loggedOut, isTrue);
  });

  testWidgets('tapping the logout icon invokes onLogout when collapsed', (
    tester,
  ) async {
    var loggedOut = false;
    await tester.pumpWidget(
      buildMenu(expanded: false, onLogout: () => loggedOut = true),
    );

    await tester.tap(find.byIcon(Icons.logout));

    expect(loggedOut, isTrue);
  });

  testWidgets('does not render a logout control when onLogout is null', (
    tester,
  ) async {
    await tester.pumpWidget(buildMenu());

    expect(find.text('Sair'), findsNothing);
  });
}
