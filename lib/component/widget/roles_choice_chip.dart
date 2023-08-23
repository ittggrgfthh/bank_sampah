import 'package:flutter/material.dart';

import '../../core/constant/colors.dart';
import '../../core/constant/theme.dart';
import '../button/rounded_button.dart';

class RoleChoiceChip extends StatefulWidget {
  final Function(String selectedRole)? onSelected;

  const RoleChoiceChip({
    super.key,
    this.onSelected,
  });

  @override
  State<RoleChoiceChip> createState() => _RoleChoiceChipState();
}

class _RoleChoiceChipState extends State<RoleChoiceChip> {
  int _selectedChoice = 0;
  Role _selectedRoleChoice = Role.warga;

  final roles = [
    Role.warga,
    Role.staff,
    Role.admin,
  ];

  final textColor = <Color>[
    MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
    MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
    MyTheme.isDarkMode ? CColors.dangerDark : CColors.dangerLight,
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      spacing: 10,
      children: List<Widget>.generate(
        roles.length,
        (index) => SizedBox(
          width: (MediaQuery.of(context).size.width / 2) - 35,
          height: 44,
          child: RoundedButton(
            name: roles[index].name,
            selected: _selectedChoice == index,
            onPressed: () {
              setState(() {
                _selectedChoice = index;
                _selectedRoleChoice = roles[index];
                widget.onSelected?.call(_selectedRoleChoice.name);
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
