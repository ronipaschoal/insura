import 'package:flutter/services.dart';

/// Formats raw digits as `000.000.000-00` while the user types.
class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final truncated = digits.length > 11 ? digits.substring(0, 11) : digits;

    final buffer = StringBuffer();
    for (var i = 0; i < truncated.length; i++) {
      buffer.write(truncated[i]);
      final isLastChar = i == truncated.length - 1;
      if (!isLastChar && (i == 2 || i == 5)) {
        buffer.write('.');
      } else if (!isLastChar && i == 8) {
        buffer.write('-');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
