import 'dart:js_interop';

import 'package:bank_sampah/component/button/rounded_primary_button.dart';
import 'package:bank_sampah/component/field/money_field.dart';
import 'package:bank_sampah/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TarikSaldoForm extends StatefulWidget {
  final User user;
  const TarikSaldoForm({super.key, required this.user});

  @override
  State<TarikSaldoForm> createState() => _TarikSaldoFormState();
}

class _TarikSaldoFormState extends State<TarikSaldoForm> {
  List<String> chipdatas = ['50.000', '100.000', '200.000', '300.000', '500.000', '1.000.000'];
  int? _selectedChoice;
  final TextEditingController _moneyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarik Saldo'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left_rounded),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _buildHeader(context),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Pilih Nominal',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 30,
              children: List<Widget>.generate(
                6,
                (index) => SizedBox(
                  height: 70,
                  width: 190,
                  child: ChoiceChip(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    label: Text('Rp. ${chipdatas[index]} ditarik'),
                    selected: _selectedChoice == index,
                    onSelected: (v) => setState(() => _selectedChoice = v ? index : null),
                    selectedColor: Colors.green,
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            MoneyField(controller: _moneyController, onTap: () => setState(() => _selectedChoice = null)),
            const SizedBox(height: 20),
            RoundedPrimaryButton(
                buttonName: 'Tarik',
                buttonTask: () {
                  if (_selectedChoice.isDefinedAndNotNull) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Rp. ${chipdatas[_selectedChoice!]}')),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blueAccent),
          child: const CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Text('AR'),
          ),
        ),
        const SizedBox(width: 10),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          direction: Axis.vertical,
          spacing: 10,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.fullName!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  widget.user.phoneNumber,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saldo',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'Rp. 200.000',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
