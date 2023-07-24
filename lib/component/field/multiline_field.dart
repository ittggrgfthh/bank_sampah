import 'package:flutter/material.dart';

class MultilineField extends StatelessWidget {
  const MultilineField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
