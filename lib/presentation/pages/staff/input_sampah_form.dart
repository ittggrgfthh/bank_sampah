import 'package:bank_sampah/component/button/rounded_primary_button.dart';
import 'package:bank_sampah/component/field/number_field.dart';
import 'package:bank_sampah/component/widget/single_list_tile.dart';
import 'package:bank_sampah/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InputSampahForm extends StatelessWidget {
  final User user;
  const InputSampahForm({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Sampah'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        reverse: true,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SingleListTile(
                  image: user.photoUrl,
                  title: user.fullName ?? 'No Name',
                  subtitle: Text(user.phoneNumber),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Berat Sampah',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _addTrashWeight(context),
              const SizedBox(height: 100),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _totalMoney(context),
                  const SizedBox(height: 20),
                  RoundedPrimaryButton(buttonName: 'Input', buttonTask: () {}),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _addTrashWeight(BuildContext context) {
    final TextEditingController organikController = TextEditingController();
    final TextEditingController inorganikController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NumberField(controller: organikController),
        const SizedBox(height: 10),
        NumberField(controller: inorganikController),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _totalMoney(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Total saldo yang Diperoleh',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          'Rp. 300.000',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
