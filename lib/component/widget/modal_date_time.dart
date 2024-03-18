import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constant/colors.dart';
import '../../core/constant/theme.dart';
import '../../core/utils/app_helper.dart';
import '../button/rounded_button.dart';

class ModalDateTime extends StatefulWidget {
  final String title;
  final int startDate;
  final int endDate;
  final void Function(int startDate, int endDate) onSelectedChanged;

  const ModalDateTime({
    super.key,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.onSelectedChanged,
  });

  @override
  State<ModalDateTime> createState() => _ModalDateTimeState();
}

class _ModalDateTimeState extends State<ModalDateTime> {
  @override
  void initState() {
    super.initState();
    startController.text = AppHelper.millisecondEpochtoString(widget.startDate);
    endController.text = AppHelper.millisecondEpochtoString(widget.endDate);
    startEpoch = widget.startDate;
    endEpoch = widget.endDate;
  }

  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  late int startEpoch;
  late int endEpoch;

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
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: startController,
                  onTap: () => _selectCupertinoDate(type: 'start'),
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Mulai',
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_today_rounded),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: endController,
                  onTap: () => _selectCupertinoDate(type: 'end'),
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Berakhir',
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_today_rounded),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 20),
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
                          widget.onSelectedChanged(startEpoch, endEpoch);
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

  Future<void> _selectCupertinoDate({required String type}) async {
    DateTime? pickedDate;
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => SizedBox(
        height: 250,
        child: CupertinoDatePicker(
          onDateTimeChanged: (DateTime newDate) => pickedDate = newDate,
          backgroundColor: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
          initialDateTime: type == 'start'
              ? DateTime.fromMillisecondsSinceEpoch(widget.startDate)
              : type == 'end'
                  ? DateTime.fromMillisecondsSinceEpoch(widget.endDate)
                  : DateTime.now(),
          use24hFormat: true,
          mode: CupertinoDatePickerMode.date,
        ),
      ),
    );

    if (pickedDate != null && type == 'start') {
      startEpoch = pickedDate!.millisecondsSinceEpoch;
      startController.text = AppHelper.millisecondEpochtoString(pickedDate!.millisecondsSinceEpoch);
    } else if (pickedDate != null && type == 'end') {
      DateTime updatedDateTime = pickedDate!.copyWith(hour: 23, minute: 59, second: 59);
      endEpoch = updatedDateTime.millisecondsSinceEpoch;
      endController.text = AppHelper.millisecondEpochtoString(pickedDate!.millisecondsSinceEpoch);
    }
  }
}
