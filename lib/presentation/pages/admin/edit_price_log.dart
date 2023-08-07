import 'package:bank_sampah/component/dummy/dummy_data.dart';
import 'package:bank_sampah/component/widget/riwayat_transaksi_list_tile.dart';
import 'package:bank_sampah/component/widget/utils.dart';
import 'package:bank_sampah/domain/entities/waste_price.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditPriceLog extends StatelessWidget {
  const EditPriceLog({super.key});

  @override
  Widget build(BuildContext context) {
    final List<WastePrice> logEditPrices = DummyData.dummyEditHarga;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Edit Harga'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left_rounded),
        ),
      ),
      body: ListView.builder(
        itemCount: logEditPrices.length,
        itemBuilder: (context, index) => Container(
          color: Colors.amber,
          child: RiwayatTransaksiListTile(
            title: Utils.millisecondEpochtoString(logEditPrices[index].createAt),
            subtitle: [logEditPrices[index].organic.toString(), logEditPrices[index].inorganic.toString()],
            trailing: [logEditPrices[index].admin.fullName!, ''],
          ),
        ),
      ),
    );
  }
}
