import 'package:bank_sampah/component/button/rounded_primary_button.dart';
import 'package:bank_sampah/component/data/choice_chips.dart';
import 'package:bank_sampah/component/model/choice_chip_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TarikSaldoForm extends StatefulWidget {
  const TarikSaldoForm({super.key});

  @override
  State<TarikSaldoForm> createState() => _TarikSaldoFormState();
}

class _TarikSaldoFormState extends State<TarikSaldoForm> {
  List<ChoiceChipData> choiceChips = ChoiceChips.all;

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
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceAround,
              children: choiceChips
                  .map((choiceChip) => Container(
                        color: Colors.amber,
                        height: 70,
                        width: 190,
                        child: ChoiceChip(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                          label: Text(choiceChip.label),
                          selected: choiceChip.isSelected,
                          onSelected: (value) => setState(() {
                            choiceChips = choiceChips.map(
                              (otherChip) {
                                final newChip = otherChip.copy(isSelected: false);

                                return choiceChip == otherChip ? newChip.copy(isSelected: value) : newChip;
                              },
                            ).toList();
                          }),
                          selectedColor: Colors.green,
                          backgroundColor: Colors.blue,
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            RoundedPrimaryButton(
                buttonName: 'Tarik',
                buttonTask: () {
                  List<ChoiceChipData> selectedChips = choiceChips.where((chip) => chip.isSelected).toList();

                  selectedChips.forEach((chip) {
                    print(chip.label);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${chip.label} dipilih')),
                    );
                  });
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
                  'Arlene McCoy',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '+62 123-4567-8934',
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
