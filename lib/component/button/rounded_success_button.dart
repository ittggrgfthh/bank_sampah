import 'package:flutter/material.dart';

import '../../core/constant/colors.dart';

class RoundedSuccessButton extends StatelessWidget {
  final VoidCallback? buttonTask;
  final String buttonName;

  const RoundedSuccessButton({
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
              const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          ),
        ),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(CColors.success),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        onPressed: buttonTask,
        child: Text(buttonName),
      ),
    );
  }
}
