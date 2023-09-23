import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constant/colors.dart';
import '../../core/constant/theme.dart';
import '../button/rounded_button.dart';

class ModalCheckBox extends StatefulWidget {
  final List<String> items;
  final List<String> initial;
  final String title;

  final void Function(List<String> selectedItem) onSelectedChanged;
  const ModalCheckBox({
    super.key,
    required this.items,
    required this.initial,
    required this.title,
    required this.onSelectedChanged,
  });

  @override
  State<ModalCheckBox> createState() => _BuildModalState();
}

class _BuildModalState extends State<ModalCheckBox> {
  List<bool?> selectedValues = [];
  List<String> selectedOption = [];
  bool? isCheckAll = false;

  @override
  void initState() {
    super.initState();

    initial();
  }

  void initial() {
    //generate list bool
    selectedValues = List<bool>.generate(widget.items.length, (index) => false);
    //check if there is filter that was on
    if (widget.initial != []) {
      for (var item in widget.initial) {
        int index = widget.items.indexOf(item);
        if (index != -1) {
          selectedValues[index] = true;
        }
      }
    }
    // check all item in selectedValue, return true if all selectedValues was true
    isCheckAll = selectedValues.every((element) => element == true);
  }

  void updateSelectedOptions() {
    List<String> selectedOptions = [];
    for (int i = 0; i < selectedValues.length; i++) {
      if (selectedValues[i] == true) {
        selectedOptions.add(widget.items[i]);
      }
    }
    widget.onSelectedChanged(selectedOptions); // Call the callback with selected options.
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.pop(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.95,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (_, controller) {
          return Container(
            color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Pilih Semua',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Checkbox(
                          value: isCheckAll,
                          onChanged: (value) => setState(() {
                            isCheckAll = value;
                            for (int i = 0; i < selectedValues.length; i++) {
                              selectedValues[i] = value;
                            }
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(
                          widget.items[index],
                          style: TextStyle(color: Theme.of(context).colorScheme.primary),
                        ),
                        value: selectedValues[index],
                        onChanged: (value) => setState(() {
                          selectedValues[index] = value;

                          if (selectedValues[index]!) {
                            selectedOption.add(widget.items[index]);
                          } else {
                            selectedOption.remove(widget.items[index]);
                          }
                        }),
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
                          updateSelectedOptions();
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
      ),
    );
  }
}
