import 'package:bank_sampah/component/string_extension.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  const PasswordField({super.key, required this.controller});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: (s) {
        if (s!.isWhitespace()) {
          return "This is a required field!";
        }
        return null;
      },
      obscureText: obscurePassword,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: "Password Field",
        helperText: "",
        hintText: "Password",
        suffixIcon: IconButton(
          onPressed: () => setState(() => obscurePassword = !obscurePassword),
          icon: Icon(
            obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
    );
  }
}
