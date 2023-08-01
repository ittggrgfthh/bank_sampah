import 'package:bank_sampah/component/widget/tarik_saldo_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TarikSaldo extends StatelessWidget {
  const TarikSaldo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarik Saldo'),
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.amber,
            child: TarikSaldoListTile(
              title: 'Arlene McCoy',
              subtitle: '+62 123-4567-8934',
              trailing: 'Rp. 200.000',
              onTap: () => context.goNamed('tarik-saldo-form'),
            ),
          ),
        ],
      ),
    );
  }
}
