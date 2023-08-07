import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../string_extension.dart';

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), ''); // Menghapus karakter non-angka
    final formattedText = _formatToThousands(text);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatToThousands(String text) {
    final formatter = NumberFormat("#,##0", "id_ID");
    final parsedValue = int.tryParse(text) ?? 0;
    return formatter.format(parsedValue);
  }
}

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
      inputFormatters: [ThousandsFormatter()],
      onChanged: onChanged,
      decoration: InputDecoration(
        helperText: "",
        prefixIcon: isLoading
            ? Padding(
                padding: const EdgeInsets.all(5.0),
                child: Transform.scale(
                  scale: 0.7,
                  child: const CircularProgressIndicator(),
                ),
              )
            : null,
        suffixIcon: Container(
          padding: const EdgeInsets.only(right: 10),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('per kg'),
            ],
          ),
        ),
      ),
    );
  }
}
