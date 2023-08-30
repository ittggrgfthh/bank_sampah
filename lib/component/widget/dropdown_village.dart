import 'package:bank_sampah/core/constant/colors.dart';
import 'package:bank_sampah/core/constant/constant_data.dart';
import 'package:bank_sampah/core/constant/theme.dart';
import 'package:flutter/material.dart';

class DropdownVillage extends StatefulWidget {
  final String? initial;
  final Function(String village)? onChanged;
  const DropdownVillage({super.key, required this.onChanged, this.initial});

  @override
  State<DropdownVillage> createState() => _DropdownVillageState();
}

class _DropdownVillageState extends State<DropdownVillage> {
  final villages = ConstantData.village;
  late String valueVillage = widget.initial ?? ConstantData.village.first;

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
        border: Border.all(color: CColors.primaryLight, width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
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
