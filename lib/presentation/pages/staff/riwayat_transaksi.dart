import 'package:bank_sampah/component/dummy/dummy_data.dart';
import 'package:bank_sampah/component/widget/riwayat_transaksi_list_tile.dart';
import 'package:bank_sampah/core/utils/currency_converter.dart';
import 'package:bank_sampah/domain/entities/transaction_waste.dart';

import 'package:bank_sampah/injection.dart';
import 'package:bank_sampah/presentation/bloc/auth_bloc/auth_bloc.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RiwayatTransaksi extends StatelessWidget {
  const RiwayatTransaksi({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TransactionWaste> transactions = DummyData.dummyTransaction;
    final user = getIt<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded, size: 32), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_rounded, size: 32), onPressed: () {}),
          SizedBox(
            height: 32,
            width: 32,
            child: GestureDetector(
              onTap: () => context.go('/profile', extra: user),
              child: const CircleAvatar(),
            ),
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
            trailing: ['5 jam yang lalu', CurrencyConverter.intToIDR(transactions[index].withdrawnBalance.withdrawn)],
          ),
        ),
      ),
    );
  }
}
