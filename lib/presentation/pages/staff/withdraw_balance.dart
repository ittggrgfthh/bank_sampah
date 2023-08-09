import 'package:bank_sampah/component/dummy/dummy_data.dart';
import 'package:bank_sampah/component/widget/withdraw_balance_list_tile.dart';
import 'package:bank_sampah/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WithdrawBalance extends StatelessWidget {
  const WithdrawBalance({super.key});

  @override
  Widget build(BuildContext context) {
    final List<User> userDatas = DummyData.dummyUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarik Saldo'),
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
        itemCount: userDatas.length,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          child: WithdrawBalanceListTile(
            photoUrl: userDatas[index].photoUrl,
            title: userDatas[index].fullName ?? 'No Name',
            subtitle: userDatas[index].phoneNumber,
            trailing: 'Rp. 200.000',
            onTap: () => context.goNamed('withdraw-balance-form', extra: userDatas[index]),
          ),
        ),
      ),
    );
  }
}
