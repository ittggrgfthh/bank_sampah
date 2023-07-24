import 'package:bank_sampah/core/constant/colors.dart';
import 'package:flutter/material.dart';

class RoundedElevatedButton extends StatelessWidget {
  const RoundedElevatedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(
              const Size.fromHeight(100),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          ),
        ),
      ),
      child: ElevatedButton(
        child: const Text('Elevated Button!'),
        onPressed: () {},
      ),
    );
  }
}
