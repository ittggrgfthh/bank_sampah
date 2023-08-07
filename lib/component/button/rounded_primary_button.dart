import 'package:flutter/material.dart';

class RoundedPrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonName;
  final bool isLoading;
  final bool isChanged;

  const RoundedPrimaryButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
    this.isLoading = false,
    this.isChanged = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color buttonBackgroundColor =
        isLoading || isChanged ? Colors.blueGrey : Theme.of(context).colorScheme.primary;
    final Color buttonPrimaryColor = Theme.of(context).colorScheme.background;
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(
              const Size.fromHeight(45),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
          ),
        ),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(buttonBackgroundColor),
          foregroundColor: MaterialStateProperty.all<Color>(buttonPrimaryColor),
        ),
        onPressed: isLoading || isChanged ? null : onPressed,
        child: isLoading
            ? Transform.scale(
                scale: 0.7,
                child: CircularProgressIndicator(
                  color: buttonPrimaryColor,
                ),
              )
            : Text(buttonName),
      ),
    );
  }
}
