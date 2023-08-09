import 'package:bank_sampah/component/dummy/dummy_data.dart';
import 'package:bank_sampah/component/widget/transaction_histry_list_tile.dart';
import 'package:bank_sampah/core/utils/date_time_converter.dart';
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
          child: TransactionHitoryListTile(
            title: DateTimeConverter.millisecondEpochtoString(logEditPrices[index].createdAt),
            subtitle: [logEditPrices[index].organic.toString(), logEditPrices[index].inorganic.toString()],
            trailing: [logEditPrices[index].admin.fullName!, ''],
          ),
        ),
      ),
    );
  }
}
