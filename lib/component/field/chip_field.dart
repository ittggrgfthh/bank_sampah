import 'package:flutter/material.dart';

class ChipField extends StatelessWidget {
  final String labelName;
  final bool selected;
  final void Function(bool)? onSelected;

  const ChipField({
    super.key,
    required this.labelName,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(labelName),
      selected: selected,
      onSelected: onSelected,
    );
  }
}
