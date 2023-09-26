import 'package:flutter/material.dart';

import '../../component/button/rounded_primary_button.dart';

class FailureInfo extends StatelessWidget {
  final String description;
  final String labelButton;
  final void Function()? onPressed;
  const FailureInfo({
    super.key,
    this.description = 'Terjadi Kesalahan',
    this.labelButton = 'Refresh',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '(T _ T)',
              style: TextStyle(
                fontSize: 36,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            onPressed == null
                ? const SizedBox()
                : RoundedPrimaryButton(
                    buttonName: labelButton,
                    onPressed: onPressed,
                  )
          ],
        ),
      ),
    );
  }
}
