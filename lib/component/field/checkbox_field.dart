import 'package:flutter/material.dart';

class CheckboxField extends StatelessWidget {
  final int selectedChoice;
  final void Function(int?) onChanged;

  const CheckboxField({
    super.key,
    required this.selectedChoice,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile(
            title: Text('Warga'),
            value: 0,
            groupValue: selectedChoice,
            onChanged: onChanged,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            toggleable: false,
          ),
        ),
        Expanded(
          child: RadioListTile(
            title: Text('Staff'),
            value: 1,
            groupValue: selectedChoice,
            onChanged: onChanged,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        Expanded(
          child: RadioListTile(
            title: Text('Admin'),
            value: 2,
            groupValue: selectedChoice,
            onChanged: onChanged,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
