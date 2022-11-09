import 'package:flutter/services.dart';

class PlayerNameFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final inputText = newValue.text;

    final arr = inputText.split(' ');

    if (arr.length > 2) {
      return oldValue;
    }

    return TextEditingValue(
      text: inputText.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
