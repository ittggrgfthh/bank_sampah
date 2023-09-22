import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constant/colors.dart';
import '../../core/constant/theme.dart';
import '../button/rounded_button.dart';

class ModalRadioButton extends StatefulWidget {
  final List<String> items;
  final String initial;
  final String title;
  final void Function(String selectedItem) onSelectedChanged;

  const ModalRadioButton({
    super.key,
    required this.items,
    required this.initial,
    required this.title,
    required this.onSelectedChanged,
  });

  @override
  State<ModalRadioButton> createState() => _BuildModalState();
}

class _BuildModalState extends State<ModalRadioButton> {
  @override
  void initState() {
    super.initState();
    selectedValues = widget.items.indexOf(widget.initial);
  }

  int? selectedValues;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (_, controller) {
        return Container(
          color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                      title: Text(
                        widget.items[index],
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                      groupValue: selectedValues,
                      onChanged: (value) {
                        setState(() {
                          selectedValues = value;
                        });
                      },
                      value: index,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: RoundedButton(
                      name: 'Batal',
                      onPressed: () => context.pop(),
                      selected: false,
                      color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
                      textColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RoundedButton(
                      name: 'Terapkan',
                      onPressed: () {
                        if (selectedValues != null) {
                          widget.onSelectedChanged(widget.items[selectedValues!]);
                        }
                      },
                      selected: true,
                      color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
                      textColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
