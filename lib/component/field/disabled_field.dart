import 'package:flutter/material.dart';

class DisabledField extends StatelessWidget {
  const DisabledField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        enabled: false,
        labelText: "Disabled field",
        helperText: "",
        hintText: "Disalbed field",
      ),
    );
  }
}
