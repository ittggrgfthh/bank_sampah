import 'package:bank_sampah/component/dummy/dummy_data.dart';
import 'package:bank_sampah/component/widget/tarik_saldo_list_tile.dart';
import 'package:bank_sampah/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TarikSaldo extends StatelessWidget {
  const TarikSaldo({super.key});

  @override
  Widget build(BuildContext context) {
    final List<User> userDatas = DummyData.dummyUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarik Saldo'),
      ),
      body: ListView.builder(
        itemCount: userDatas.length,
        itemBuilder: (context, index) => Container(
          color: Colors.amber,
          child: TarikSaldoListTile(
            image: userDatas[index].photoUrl,
            title: userDatas[index].fullName ?? 'No Name',
            subtitle: userDatas[index].phoneNumber,
            trailing: 'Rp. 200.000',
            onTap: () => context.goNamed('tarik-saldo-form', extra: userDatas[index]),
          ),
        ),
      ),
    );
  }
}
