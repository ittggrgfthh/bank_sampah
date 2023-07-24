import 'package:flutter/material.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      maxLength: 13,
      decoration: const InputDecoration(
        counterText: "",
        labelText: "Nomor Telepon",
        hintText: "Nomor Telepon",
        helperText: "",
      ),
    );
  }
}
