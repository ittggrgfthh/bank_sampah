import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constant/colors.dart';
import '../../core/constant/theme.dart';
import '../../core/utils/app_helper.dart';
import '../button/rounded_button.dart';

class ModalDateTime extends StatefulWidget {
  final String title;
  final String startDate;
  final String endDate;
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
    startController.text = widget.startDate;
    endController.text = widget.endDate;
  }

  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
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
                onTap: () => _selectDate(type: 'start'),
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
                onTap: () => _selectDate(type: 'end'),
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
                        int dateStart = AppHelper.stringToMillisecondEpoch(startController.text);
                        int dateEnd = AppHelper.stringToMillisecondEpoch(endController.text);

                        widget.onSelectedChanged(dateStart, dateEnd);
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

  Future<void> _selectDate({required String type}) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && type == 'start') {
      startController.text = picked.toString().split(" ")[0];
    } else if (picked != null && type == 'end') {
      endController.text = picked.toString().split(" ")[0];
    }
  }
}
