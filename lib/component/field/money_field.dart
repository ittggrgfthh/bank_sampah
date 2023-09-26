import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
  final String? suffixText;
  final String? Function(String? value)? validator;
  final void Function()? onTap;
  final String? hintText;
  final String? initialValue;

  const MoneyField({
    super.key,
    this.controller,
    this.onChanged,
    this.isLoading = false,
    this.onTap,
    this.suffixText,
    this.validator,
    this.hintText,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: !isLoading,
      initialValue: initialValue,
      onTap: onTap,
      controller: controller,
      keyboardType: TextInputType.number,
      validator: validator,
      inputFormatters: [ThousandsFormatter()],
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
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
        suffixIcon: suffixText == null
            ? null
            : Container(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(suffixText!),
                  ],
                ),
              ),
      ),
    );
  }
}
