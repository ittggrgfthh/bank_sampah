import 'package:flutter/material.dart';

class RoundedNoColorButton extends StatelessWidget {
  final String task;
  final VoidCallback? buttonTask;

  const RoundedNoColorButton({super.key, required this.task, this.buttonTask});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border:
            Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),
          ),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            foregroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          child: const Text('Elevated Button!'),
          onPressed: () => print(task),
        ),
      ),
    );
  }
}
