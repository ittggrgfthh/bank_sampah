import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/widget/transaction_histry_list_tile.dart';
import '../../../core/utils/date_time_converter.dart';
import '../../../injection.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/transaction_history/transaction_history_bloc.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final staff = context.read<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
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
      body: BlocProvider(
        create: (context) => getIt<TransactionHistoryBloc>()..add(TransactionHistoryEvent.initialized(staff.id)),
        child: BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
          builder: (context, state) {
            return state.maybeWhen(
              loadSuccess: (transactions) {
                if (transactions.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada transaksi'),
                  );
                }
                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      child: TransactionHitoryListTile(
                        title: transaction.user.fullName!,
                        photoUrl: transaction.user.photoUrl,
                        subtitle: [transaction.waste.organic.toString(), transaction.waste.inorganic.toString()],
                        trailing: [
                          DateTimeConverter.timeAgoFromMillisecond(transaction.createdAt),
                          transaction.withdrawnBalance.withdrawn.toString()
                        ],
                      ),
                    );
                  },
                );
              },
              loadFailure: (_) => const Center(
                child: Column(
                  children: [
                    Text(
                      '(ノ_<、)',
                      style: TextStyle(
                        fontSize: 36,
                      ),
                    ),
                    Text('Terjadi kesalahan'),
                  ],
                ),
              ),
              orElse: () => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}
