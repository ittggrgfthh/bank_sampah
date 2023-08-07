import 'package:bank_sampah/component/button/rounded_primary_button.dart';
import 'package:bank_sampah/component/dummy/dummy_data.dart';
import 'package:bank_sampah/component/field/money_field.dart';
import 'package:bank_sampah/component/widget/utils.dart';
import 'package:bank_sampah/domain/entities/waste_price.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditHarga extends StatelessWidget {
  const EditHarga({super.key});

  @override
  Widget build(BuildContext context) {
    final organikController = TextEditingController();
    final anOrganikController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Harga')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          runSpacing: 20,
          children: [
            _buildHeader(context),
            _buildForm(organikController, anOrganikController),
            RoundedPrimaryButton(
                buttonName: 'Simpan',
                buttonTask: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Berhasil Tersimpan')),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final List<WastePrice> wastePrice = DummyData.dummyEditHarga;
    final WastePrice lastItem = wastePrice.last;
    String timeAgo = Utils.timeAgoFromMillisecond(lastItem.createAt);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 5,
              children: [
                IconButton(
                  icon: const Icon(Icons.timelapse),
                  onPressed: () => context.goNamed('log-edit-price'),
                ),
                Text(timeAgo),
              ],
            ),
            Wrap(
              spacing: 5,
              children: [
                const Icon(Icons.group),
                Text('Oleh ${lastItem.admin.fullName}'),
              ],
            ),
          ],
        ),
        Container(
          width: 50,
          height: 50,
          color: Colors.amber,
          child: const Icon(Icons.history),
        ),
      ],
    );
  }

  Widget _buildForm(TextEditingController organikController, TextEditingController anOrganikController) {
    return Wrap(
      runSpacing: 8,
      children: [
        const Text('Organik (Rp)'),
        MoneyField(controller: organikController),
        const Text('An-Organik (Rp)'),
        MoneyField(controller: anOrganikController),
      ],
    );
  }
}
