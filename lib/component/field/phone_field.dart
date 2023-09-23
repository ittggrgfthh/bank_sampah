import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newTextBuffer = StringBuffer();
    if (newTextLength >= 4) {
      newTextBuffer.write('${newValue.text.substring(usedSubstringIndex, usedSubstringIndex = 3)}-');
      if (newValue.selection.end >= 4) selectionIndex++;
    }
    if (newTextLength >= 8) {
      newTextBuffer.write('${newValue.text.substring(usedSubstringIndex, usedSubstringIndex = 7)}-');
      if (newValue.selection.end >= 7) selectionIndex++;
    }
    if (newTextLength >= 12) {
      newTextBuffer.write('${newValue.text.substring(usedSubstringIndex, usedSubstringIndex = 11)}-');
      if (newValue.selection.end >= 11) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex) newTextBuffer.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newTextBuffer.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class PhoneField extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const PhoneField({
    super.key,
    this.controller,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.validator,
    this.suffixIcon,
    this.initialValue,
  });

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  String counterText = "0/13";
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      controller: widget.controller,
      validator: widget.validator,
      onChanged: (value) {
        setState(() {
          counterText = "${value.length}/13";
        });
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        NumberTextInputFormatter(),
      ],
      keyboardType: TextInputType.phone,
      textInputAction: widget.textInputAction,
      maxLength: 13,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        counterText: counterText,
        labelText: "Nomor Telepon",
        hintText: "812-3456-7890",
        helperText: "",
        suffixIcon: widget.suffixIcon,
        prefixIcon: Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 4, 16),
          child: Text(
            '+62',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
