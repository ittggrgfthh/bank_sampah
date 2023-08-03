import 'package:bank_sampah/component/model/choice_chip_data.dart';
import 'package:flutter/material.dart';

class ChoiceChips {
  static final all = <ChoiceChipData>[
    ChoiceChipData(
      label: 'Warga',
      isSelected: false,
      textColor: Colors.blue,
      selectedColor: Colors.white,
    ),
    ChoiceChipData(
      label: 'Staff',
      isSelected: false,
      textColor: Colors.blue,
      selectedColor: Colors.white,
    ),
    ChoiceChipData(
      label: 'Admin',
      isSelected: false,
      textColor: Colors.blue,
      selectedColor: Colors.white,
    ),
  ];
}
