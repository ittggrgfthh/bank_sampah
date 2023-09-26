import 'package:flutter/material.dart';

import '../string_extension.dart';
import 'money_field.dart';

class NumberField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final Widget? icon;
  final String? helperText;
  final ValueChanged<String>? onChanged;
  final bool isLoading;
  const NumberField({
    super.key,
    this.controller,
    this.icon,
    this.helperText,
    this.onChanged,
    this.isLoading = false,
    required this.label,
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
      inputFormatters: [ThousandsFormatter()],
      decoration: InputDecoration(
        label: Text(label),
        enabled: !isLoading,
        helperText: helperText ?? '',
        prefix: icon,
        suffixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'kg',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
