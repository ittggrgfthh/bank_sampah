import 'package:bank_sampah/core/constant/colors.dart';
import 'package:flutter/material.dart';

class RoundedSuccessButton extends StatelessWidget {
  final String task;

  const RoundedSuccessButton({
    super.key,
    required this.task,
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
          backgroundColor: MaterialStateProperty.all<Color>(CColors.success),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        child: const Text('Elevated Button!'),
        onPressed: () => print(task),
      ),
    );
  }
}
