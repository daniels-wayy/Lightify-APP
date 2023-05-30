import 'package:flutter/services.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';

class FirstUpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.capitalizeFirstLetter);
  }
}
