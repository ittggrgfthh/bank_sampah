import 'package:bank_sampah/core/constant/constant_data.dart';
import 'package:flutter/material.dart';

import '../../core/constant/colors.dart';
import '../../core/constant/theme.dart';
import '../button/rounded_button.dart';

class RoleChoiceChip extends StatefulWidget {
  final String? initial;
  final Function(String selectedRole)? onSelected;

  const RoleChoiceChip({
    super.key,
    this.onSelected,
    this.initial = 'warga',
  });

  @override
  State<RoleChoiceChip> createState() => _RoleChoiceChipState();
}

class _RoleChoiceChipState extends State<RoleChoiceChip> {
  final roles = ConstantData.roles;
  String choicedRole = 'warga';

  final textColor = <Color>[
    MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
    MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
    MyTheme.isDarkMode ? CColors.dangerDark : CColors.dangerLight,
  ];

  @override
  Widget build(BuildContext context) {
    choicedRole = widget.initial!;
    return Wrap(
      direction: Axis.vertical,
      spacing: 10,
      children: List<Widget>.generate(
        roles.length,
        (index) => SizedBox(
          width: (MediaQuery.of(context).size.width / 2) - 35,
          height: 44,
          child: RoundedButton(
            name: roles[index],
            selected: choicedRole == roles[index],
            onPressed: () {
              setState(() {
                choicedRole = roles[index];
                widget.onSelected?.call(roles[index]);
              });
            },
            color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
            textColor: textColor[index],
          ),
        ),
      ),
    );
  }
}

enum Role { admin, staff, warga }
