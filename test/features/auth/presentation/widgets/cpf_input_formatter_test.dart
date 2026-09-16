import 'package:flutter_test/flutter_test.dart';
import 'package:insura/features/auth/presentation/widgets/cpf_input_formatter.dart';

void main() {
  late CpfInputFormatter formatter;

  setUp(() => formatter = CpfInputFormatter());

  TextEditingValue format(String text) {
    return formatter.formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(text: text),
    );
  }

  test('inserts dots and a dash as digits accumulate', () {
    expect(format('1').text, '1');
    expect(format('123').text, '123');
    expect(format('1234').text, '123.4');
    expect(format('123456').text, '123.456');
    expect(format('1234567').text, '123.456.7');
    expect(format('123456789').text, '123.456.789');
    expect(format('1234567890').text, '123.456.789-0');
    expect(format('12345678909').text, '123.456.789-09');
  });

  test('truncates input beyond 11 digits', () {
    expect(format('123456789099999').text, '123.456.789-09');
  });

  test('strips non-digit characters before formatting', () {
    expect(format('123.456.789-09').text, '123.456.789-09');
    expect(format('abc123def456').text, '123.456');
  });

  test('places the cursor at the end of the formatted text', () {
    final result = format('12345678909');

    expect(result.selection.baseOffset, result.text.length);
    expect(result.selection.extentOffset, result.text.length);
  });

  test('formats an empty string to an empty value', () {
    expect(format('').text, '');
  });
}
