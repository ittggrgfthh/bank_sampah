import 'package:bank_sampah/component/string_extension.dart';
import 'package:flutter/material.dart';

class NumberField extends StatelessWidget {
  final TextEditingController controller;
  const NumberField({super.key, required this.controller});

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
      decoration: const InputDecoration(suffix: Text('Kg')),
    );
  }
}
