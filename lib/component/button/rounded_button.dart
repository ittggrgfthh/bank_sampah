import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String name;
  final bool selected;
  final bool? enable;
  final Color color;
  final Color textColor;

  const RoundedButton({
    super.key,
    required this.name,
    required this.onPressed,
    required this.selected,
    this.enable,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(const Size.fromHeight(45)),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                side: BorderSide(color: textColor),
              ),
            ),
          ),
        ),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              selected ? MaterialStateProperty.all<Color>(textColor) : MaterialStateProperty.all<Color>(color),
          foregroundColor:
              selected ? MaterialStateProperty.all<Color>(color) : MaterialStateProperty.all<Color>(textColor),
        ),
        onPressed: onPressed,
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
