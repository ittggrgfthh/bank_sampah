import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../string_extension.dart';

class CustomNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final filteredValue = newValue.text.replaceAll(RegExp(r'[-.]'), '');
    // Menghapus karakter pertama jika panjang teks melebihi 3 digit
    final trimmedValue = filteredValue.length > 3 ? filteredValue.substring(1) : filteredValue;

    final numericValue = int.tryParse(trimmedValue);
    if (numericValue != null) {
      final formattedValue = numericValue.toString();

      // Menyusun teks dengan tambahan nol di depan jika panjangnya kurang dari 3
      final newText = formattedValue.padLeft(3, '0');

      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
    return newValue;
  }
}

class RtrwField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final Widget? icon;
  final String? helperText;
  final ValueChanged<String>? onChanged;
  final bool isLoading;
  final String? hintText;
  const RtrwField({
    super.key,
    this.controller,
    this.initialValue,
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
      initialValue: initialValue,
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
