import 'package:bank_sampah/component/string_extension.dart';
import 'package:flutter/material.dart';

class MoneyField extends StatelessWidget {
  final TextEditingController controller;
  final void Function()? onTap;

  const MoneyField({super.key, required this.controller, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      keyboardType: TextInputType.number,
      validator: (s) {
        if (!s!.isValidDouble()) {
          return "Enter a valid number!";
        }
        return null;
      },
      decoration: const InputDecoration(
        helperText: "",
        hintText: 'Atau, ketik sendiri nominalnya',
      ),
    );
  }
}
