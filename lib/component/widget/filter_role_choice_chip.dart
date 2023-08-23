import 'package:flutter/material.dart';

class FilterRoleChoiceChip extends StatefulWidget {
  final Function(String selectedRole)? onSelected;
  const FilterRoleChoiceChip({
    super.key,
    this.onSelected,
  });

  @override
  State<FilterRoleChoiceChip> createState() => _FilterRoleChoiceChipState();
}

class _FilterRoleChoiceChipState extends State<FilterRoleChoiceChip> {
  int _selectedChoice = 0;
  String _selectedRoleChoice = 'warga';

  final roles = [
    'semua',
    'warga',
    'staff',
    'admin',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(
        roles.length,
        (index) => Container(
          margin: const EdgeInsets.only(right: 10),
          child: ChoiceChip(
            label: Text(
              roles[index],
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            selected: _selectedChoice == index,
            onSelected: (selectedIndex) {
              setState(() {
                _selectedChoice = index;
                _selectedRoleChoice = roles[index];
                widget.onSelected?.call(_selectedRoleChoice);
              });
            },
          ),
        ),
      ),
    );
  }
}
