import 'package:flutter/material.dart';

class NameField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final String labelText;
  final String helperText;
  final String hintText;
  final TextInputType keyboardType;
  final Function(String value)? onChanged;
  final String? Function(String? value)? validator;

  const NameField({
    super.key,
    this.controller,
    this.keyboardType = TextInputType.name,
    this.textInputAction = TextInputAction.next,
    this.labelText = 'Nama Lengkap',
    this.hintText = 'Nama Lengkap',
    this.helperText = '',
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
      ),
    );
  }
}
