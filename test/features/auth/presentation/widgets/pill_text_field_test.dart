import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insura/features/auth/presentation/widgets/cpf_input_formatter.dart';
import 'package:insura/features/auth/presentation/widgets/pill_text_field.dart';

void main() {
  testWidgets('renders the given hint text', (tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PillTextField(controller: controller, hint: 'CPF'),
        ),
      ),
    );

    expect(find.text('CPF'), findsOneWidget);
  });

  testWidgets('obscures the input when obscureText is true', (tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PillTextField(
            controller: controller,
            hint: 'Senha',
            obscureText: true,
          ),
        ),
      ),
    );

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.obscureText, isTrue);
  });

  testWidgets('applies the given input formatters', (tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PillTextField(
            controller: controller,
            hint: 'CPF',
            inputFormatters: [CpfInputFormatter()],
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '12345678909');

    expect(controller.text, '123.456.789-09');
  });
}
