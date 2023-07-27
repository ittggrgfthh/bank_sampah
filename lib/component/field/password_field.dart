import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final String labelText;
  final String helperText;
  final String hintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    this.controller,
    this.textInputAction = TextInputAction.next,
    this.labelText = 'Password',
    this.helperText = '',
    this.hintText = 'Password',
    this.onChanged,
    this.validator,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      validator: widget.validator,
      obscureText: obscurePassword,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        helperText: widget.helperText,
        hintText: widget.hintText,
        suffixIcon: IconButton(
          onPressed: () => setState(() => obscurePassword = !obscurePassword),
          icon: Icon(
            obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
