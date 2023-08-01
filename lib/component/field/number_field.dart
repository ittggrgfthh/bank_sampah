import 'package:bank_sampah/component/string_extension.dart';
import 'package:flutter/material.dart';

class NumberField extends StatelessWidget {
  final TextEditingController controller;
  final Widget? icon;
  const NumberField({super.key, required this.controller, this.icon});

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
      decoration: InputDecoration(
        helperText: "",
        prefix: icon,
        suffix: Text(
          'kg',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
