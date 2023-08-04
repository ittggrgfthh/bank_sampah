import 'package:bank_sampah/component/data/dummy_data.dart';
import 'package:bank_sampah/component/widget/riwayat_transaksi_list_tile.dart';
import 'package:bank_sampah/domain/entities/user.dart';
import 'package:flutter/material.dart';

class RiwayatTransaksi extends StatelessWidget {
  const RiwayatTransaksi({super.key});

  @override
  Widget build(BuildContext context) {
    final List<User> userDatas = DummyData.dummyUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi')),
      body: ListView.builder(
        itemCount: userDatas.length,
        itemBuilder: (context, index) => Container(
          color: Colors.amber,
          child: RiwayatTransaksiListTile(
            title: userDatas[index].fullName ?? 'No Name',
            image: userDatas[index].photoUrl,
            subtitle: const ['100', '70'],
            trailing: const ['5 jam yang lalu', 'Rp. 221.000'],
          ),
        ),
      ),
    );
  }
}
