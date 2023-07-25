import 'package:flutter/material.dart';

class RoundedPrimaryButton extends StatelessWidget {
  final VoidCallback? buttonTask;
  final String buttonName;

  const RoundedPrimaryButton({
    super.key,
    required this.buttonName,
    required this.buttonTask,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(
              const Size.fromHeight(45),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          ),
        ),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.primary,
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.background,
          ),
        ),
        onPressed: buttonTask,
        child: Text(buttonName),
      ),
    );
  }
}
