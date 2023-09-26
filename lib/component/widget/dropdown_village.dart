import 'package:flutter/material.dart';

import '../../core/constant/colors.dart';
import '../../core/constant/default_data.dart';
import '../../core/constant/theme.dart';

class DropdownVillage extends StatefulWidget {
  final String? initial;
  final Function(String village)? onChanged;
  const DropdownVillage({super.key, required this.onChanged, this.initial});

  @override
  State<DropdownVillage> createState() => _DropdownVillageState();
}

class _DropdownVillageState extends State<DropdownVillage> {
  final villages = DefaultData.village;
  late String valueVillage = widget.initial ?? DefaultData.village.first;

  @override
  Widget build(BuildContext context) {
    widget.onChanged?.call(valueVillage);
    return _DropdownVillageStyle(
      items: villages,
      onChanged: (value) => setState(() => valueVillage = value!),
      value: valueVillage,
    );
  }
}

class _DropdownVillageStyle extends StatelessWidget {
  final List<String> items;
  final void Function(String?)? onChanged;
  final String? value;

  const _DropdownVillageStyle({
    required this.items,
    this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
          items: items.map((item) => buildMenuItem(context, item)).toList(),
          onChanged: onChanged,
          value: value,
          style: TextStyle(
            backgroundColor: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
          ),
          // isExpanded: true,
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(BuildContext context, String item) => DropdownMenuItem(
        value: item,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            item,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
}
