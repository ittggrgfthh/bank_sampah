import 'package:bank_sampah/core/constant/colors.dart';
import 'package:flutter/material.dart';

class RoundedDangerButton extends StatelessWidget {
  final VoidCallback? buttonTask;
  final String buttonName;

  const RoundedDangerButton({
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
              const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
        ),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(CColors.danger),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        onPressed: buttonTask,
        child: Text(buttonName),
      ),
    );
  }
}
