import 'package:bank_sampah/component/string_extension.dart';
import 'package:flutter/material.dart';

class NameField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final String labelText;
  final String helperText;
  final String hintText;
  final TextInputType keyboardType;

  const NameField({
    super.key,
    this.controller,
    this.keyboardType = TextInputType.name,
    this.textInputAction = TextInputAction.next,
    this.labelText = 'Nama Lengkap',
    this.hintText = 'Nama Lengkap',
    this.helperText = '',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (s) {
        if (s!.isWhitespace()) {
          return "This is a required field!";
        }
        return null;
      },
      keyboardType: keyboardType,
      textInputAction: textInputAction,
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
