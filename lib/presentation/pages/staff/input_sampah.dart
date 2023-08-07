import 'package:bank_sampah/component/dummy/dummy_data.dart';
import 'package:bank_sampah/component/widget/tarik_saldo_list_tile.dart';
import 'package:bank_sampah/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InputSampah extends StatelessWidget {
  const InputSampah({super.key});

  @override
  Widget build(BuildContext context) {
    final List<User> userDatas = DummyData.dummyUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Sampah'),
      ),
      body: ListView.builder(
        itemCount: userDatas.length,
        itemBuilder: (context, index) => Container(
          color: Colors.amber,
          child: TarikSaldoListTile(
            title: userDatas[index].fullName ?? 'No Name',
            subtitle: userDatas[index].phoneNumber,
            trailing: 'Rp. 200.000',
            image: userDatas[index].photoUrl,
            onTap: () => context.goNamed('input-waste-form', extra: userDatas[index]),
          ),
        ),
      ),
    );
  }
}
