import 'package:flutter/material.dart';

class RoundedDropdownButton extends StatelessWidget {
  final List<String> items;
  final void Function(String?)? onChanged;
  final String? value;
  const RoundedDropdownButton({
    super.key,
    required this.items,
    this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary,
            offset: const Offset(1, 1),
            blurRadius: 0.5,
            spreadRadius: 0.2,
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          items: items.map((item) => buildMenuItem(context, item)).toList(),
          onChanged: onChanged,
          value: value,
          // isExpanded: true,
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(BuildContext context, String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}
