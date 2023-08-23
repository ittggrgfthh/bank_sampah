import 'package:bank_sampah/component/button/rounded_dropdown_button.dart';
import 'package:bank_sampah/core/constant/constant_data.dart';
import 'package:flutter/material.dart';

class DropdownVillage extends StatefulWidget {
  const DropdownVillage({super.key});

  @override
  State<DropdownVillage> createState() => _DropdownVillageState();
}

class _DropdownVillageState extends State<DropdownVillage> {
  final village = ConstantData.village;
  String? valueVillage;

  @override
  Widget build(BuildContext context) {
    return RoundedDropdownButton(
      items: village,
      onChanged: (value) => setState(() => valueVillage = value),
      value: valueVillage,
    );
  }
}
