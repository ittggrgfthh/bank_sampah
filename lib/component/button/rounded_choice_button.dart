import 'package:bank_sampah/core/constant/colors.dart';
import 'package:bank_sampah/core/constant/theme.dart';
import 'package:flutter/material.dart';

class RoundedChoiceButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String name;
  final bool selected;
  final bool? enable;

  const RoundedChoiceButton({
    super.key,
    required this.name,
    required this.onPressed,
    required this.selected,
    this.enable,
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
                side: BorderSide(color: MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight),
              ),
            ),
          ),
        ),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: selected
              ? MaterialStateProperty.all<Color>(MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight)
              : MaterialStateProperty.all<Color>(MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight),
          foregroundColor: selected
              ? MaterialStateProperty.all<Color>(MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight)
              : MaterialStateProperty.all<Color>(MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight),
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