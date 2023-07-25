import 'package:bank_sampah/component/string_extension.dart';
import 'package:flutter/material.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;

  const PhoneField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (s) {
        if (s!.isWhitespace()) {
          return "Tolong isi nomor telepon!";
        }
        return null;
      },
      keyboardType: TextInputType.phone,
      maxLength: 13,
      decoration: const InputDecoration(
        counterText: "",
        labelText: "Telepon",
        hintText: "Nomor Telepon",
        helperText: "",
      ),
    );
  }
}
