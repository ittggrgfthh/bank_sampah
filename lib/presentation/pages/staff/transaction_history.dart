import 'package:bank_sampah/core/routing/router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
          Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              onTap: () => context.go('${AppRouterName.staffHistoryTransactionPath}/${AppRouterName.profilePath}'),
              child: Ink.image(
                width: 32,
                height: 32,
                image: CachedNetworkImageProvider(staff.photoUrl ??
                    'https://avatars.mds.yandex.net/i?id=1b0ce6ca8b11735031618d51e2a7e336f6d6f7b5-9291521-images-thumbs&n=13'),
              ),
            ),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '(ノ_<、)',
                          style: TextStyle(
                            fontSize: 36,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text('Belum ada transaksi!'),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    print(DateTimeConverter.isWithin30Minutes(transaction.createdAt));
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      child: TransactionHitoryListTile(
                        enabled: transaction.storeWaste != null &&
                            DateTimeConverter.isWithin30Minutes(transaction.createdAt),
                        title: transaction.user.fullName!,
                        photoUrl: transaction.user.photoUrl,
                        subtitle: [
                          transaction.storeWaste == null ? '0' : transaction.storeWaste!.waste.organic.toString(),
                          transaction.storeWaste == null ? '0' : transaction.storeWaste!.waste.inorganic.toString(),
                          transaction.withdrawnBalance == null
                              ? '0'
                              : getIt<NumberFormat>().format(transaction.withdrawnBalance!.withdrawn),
                        ],
                        trailing: [
                          DateTimeConverter.timeAgoFromMillisecond(transaction.createdAt),
                          transaction.storeWaste == null
                              ? '-'
                              : getIt<NumberFormat>().format(transaction.storeWaste!.earnedBalance),
                        ],
                      ),
                    );
                  },
                );
              },
              loadFailure: (_) => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '(ノ_<、)',
                      style: TextStyle(
                        fontSize: 36,
                      ),
                    ),
                    SizedBox(height: 5),
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
