import 'package:flutter/material.dart';

import '../string_extension.dart';
import 'money_field.dart';

class NumberField extends StatelessWidget {
  final Widget? label;
  final TextEditingController? controller;
  final Widget? prefix;
  final String? helperText;
  final String? hintText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final List<Widget>? postfix;
  final bool isLoading;
  const NumberField({
    super.key,
    this.controller,
    this.prefix,
    this.helperText,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.postfix,
    this.isLoading = false,
    this.label,
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
      initialValue: initialValue,
      onChanged: onChanged,
      inputFormatters: [ThousandsFormatter()],
      decoration: InputDecoration(
        label: label,
        enabled: !isLoading,
        hintText: hintText,
        helperText: helperText ?? '',
        prefix: prefix,
        suffixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: postfix ?? [const SizedBox.shrink()],
        ),
      ),
    );
  }
}
