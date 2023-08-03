import 'package:bank_sampah/component/widget/riwayat_transaksi_list_tile.dart';
import 'package:flutter/material.dart';

class RiwayatTransaksi extends StatelessWidget {
  const RiwayatTransaksi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi')),
      body: ListView(
        children: [
          Container(
            color: Colors.amber,
            child: const RiwayatTransaksiListTile(
              title: 'Arlene McCoy',
              // image: 'assets/images/logo.png',
              subtitle: ['100', '70'],
              trailing: ['5 jam yang lalu', 'Rp. 221.000'],
            ),
          ),
        ],
      ),
    );
  }
}
