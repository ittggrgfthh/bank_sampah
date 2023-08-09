import 'package:bank_sampah/component/dummy/dummy_data.dart';
import 'package:bank_sampah/component/widget/riwayat_transaksi_list_tile.dart';
import 'package:bank_sampah/domain/entities/transaction_waste.dart';
import 'package:bank_sampah/domain/entities/user.dart';
import 'package:flutter/material.dart';

class RiwayatTransaksi extends StatelessWidget {
  const RiwayatTransaksi({super.key});

  @override
  Widget build(BuildContext context) {
    final List<User> userDatas = DummyData.dummyUser;
    final List<TransactionWaste> transactions = DummyData.dummyTransaction;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded, size: 32), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_rounded, size: 32), onPressed: () {}),
          const SizedBox(
            height: 32,
            width: 32,
            child: CircleAvatar(),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          child: RiwayatTransaksiListTile(
            title: transactions[index].user.fullName!,
            image: transactions[index].user.photoUrl,
            subtitle: [transactions[index].waste.organic.toString(), transactions[index].waste.inorganic.toString()],
            trailing: ['5 jam yang lalu', transactions[index].withdrawnBalance.withdrawn.toString()],
          ),
        ),
      ),
    );
  }
}
