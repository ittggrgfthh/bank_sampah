import 'package:bank_sampah/component/string_extension.dart';
import 'package:flutter/material.dart';

class NumberField extends StatelessWidget {
  const NumberField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      validator: (s) {
        if (!s!.isValidDouble()) {
          return "Enter a valid number!";
        }
      },
      decoration: const InputDecoration(suffix: Text('Kg')),
    );
  }
}
