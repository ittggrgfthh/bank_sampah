import 'package:bank_sampah/component/string_extension.dart';
import 'package:flutter/material.dart';

class MoneyField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool isLoading;
  final void Function()? onTap;

  const MoneyField({super.key, this.controller, this.onChanged, this.isLoading = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: !isLoading,
      onTap: onTap,
      controller: controller,
      keyboardType: TextInputType.number,
      validator: (s) {
        if (!s!.isValidDouble()) {
          return "Enter a valid number!";
        }
        return null;
      },
      onChanged: onChanged,
      decoration: InputDecoration(
        helperText: "",
        suffixIcon: isLoading
            ? Padding(
                padding: const EdgeInsets.all(5.0),
                child: Transform.scale(
                  scale: 0.7,
                  child: const CircularProgressIndicator(),
                ),
              )
            : null,
      ),
    );
  }
}
