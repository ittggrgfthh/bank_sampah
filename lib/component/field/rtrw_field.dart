import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../string_extension.dart';

class CustomNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final filteredValue = newValue.text.replaceAll(RegExp(r'[-.]'), '');
    final numericValue = int.tryParse(filteredValue);
    if (numericValue != null) {
      final formattedValue = numericValue.toString().padLeft(3, '0');
      return TextEditingValue(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length),
      );
    }
    return newValue;
  }
}

class RtrwField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final Widget? icon;
  final String? helperText;
  final ValueChanged<String>? onChanged;
  final bool isLoading;
  final String? hintText;
  const RtrwField({
    super.key,
    this.controller,
    this.icon,
    this.helperText,
    this.onChanged,
    this.isLoading = false,
    required this.label,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      validator: (s) {
        if (!s!.isValidDouble()) {
          return "Enter a valid number!";
        }
        return null;
      },
      onChanged: onChanged,
      inputFormatters: [
        CustomNumberFormatter(),
        LengthLimitingTextInputFormatter(3),
      ],
      decoration: InputDecoration(
        label: Text(label),
        enabled: !isLoading,
        hintText: hintText,
        helperText: helperText ?? '',
        prefix: icon,
      ),
    );
  }
}
