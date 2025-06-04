import 'package:flutter/services.dart';

class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove tudo que não for número
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limita a 8 dígitos
    if (digitsOnly.length > 8) {
      digitsOnly = digitsOnly.substring(0, 8);
    }

    // Formata como 00000-000
    String formatted = digitsOnly;
    if (digitsOnly.length > 5) {
      formatted = '${digitsOnly.substring(0, 5)}-${digitsOnly.substring(5)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
