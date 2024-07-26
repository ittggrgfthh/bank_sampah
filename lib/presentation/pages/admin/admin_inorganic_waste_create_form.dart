import 'package:bank_sampah/component/button/rounded_primary_button.dart';
import 'package:bank_sampah/component/field/money_field.dart';
import 'package:bank_sampah/component/field/name_field.dart';
import 'package:flutter/material.dart';

class AdminInorganicWasteCreateForm extends StatelessWidget {
  const AdminInorganicWasteCreateForm({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Sampah An-Organik'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: <Widget>[
            const Text('Nama Sampah An-organik'),
            _whitespace(),
            NameField(
              hintText: 'Kaleng, Plastik, dll',
              keyboardType: TextInputType.text,
              onChanged: (value) {},
            ),
            const Text('Harga Sampah An-organik (Rp)'),
            _whitespace(),
            MoneyField(
              hintText: '1000',
              suffixText: 'per kg',
              onChanged: (value) {},
            ),
            RoundedPrimaryButton(
              buttonName: 'Simpan',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _whitespace([double? height = 10]) => SizedBox(height: height);
}
