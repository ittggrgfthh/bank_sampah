import 'package:flutter/material.dart';

class MultilineField extends StatelessWidget {
  final TextEditingController controller;
  const MultilineField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 5,
      decoration: const InputDecoration(
        helperText: "",
        hintText: "Multiline",
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text('Label can be a widget'),
            ),
          ],
        ),
      ),
    );
  }
}
