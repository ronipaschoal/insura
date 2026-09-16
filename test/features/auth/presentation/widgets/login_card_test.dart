import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insura/features/auth/presentation/widgets/login_card.dart';

void main() {
  Widget buildCard({
    bool rememberMe = true,
    bool isLoading = false,
    ValueChanged<bool?>? onRememberMeChanged,
    VoidCallback? onSubmit,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: LoginCard(
          cpfController: TextEditingController(),
          passwordController: TextEditingController(),
          rememberMe: rememberMe,
          onRememberMeChanged: onRememberMeChanged ?? (_) {},
          isLoading: isLoading,
          onSubmit: onSubmit,
        ),
      ),
    );
  }

  testWidgets('renders the CPF/Senha fields and the remember-me checkbox', (
    tester,
  ) async {
    await tester.pumpWidget(buildCard());

    expect(find.text('CPF'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.text('Lembrar Sempre'), findsOneWidget);
  });

  testWidgets('tapping the submit button invokes onSubmit', (tester) async {
    var submitted = false;
    await tester.pumpWidget(buildCard(onSubmit: () => submitted = true));

    await tester.tap(find.byIcon(Icons.arrow_forward));

    expect(submitted, isTrue);
  });

  testWidgets('toggling the checkbox invokes onRememberMeChanged', (
    tester,
  ) async {
    bool? newValue;
    await tester.pumpWidget(
      buildCard(rememberMe: true, onRememberMeChanged: (value) => newValue = value),
    );

    await tester.tap(find.byType(Checkbox));

    expect(newValue, isFalse);
  });

  testWidgets('shows a progress indicator instead of the arrow when loading', (
    tester,
  ) async {
    await tester.pumpWidget(buildCard(isLoading: true));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsNothing);
  });
}
