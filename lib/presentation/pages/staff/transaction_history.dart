import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../component/widget/avatar_image.dart';
import '../../../component/widget/transaction_histry_list_tile.dart';
import '../../../core/constant/colors.dart';
import '../../../core/routing/router.dart';
import '../../../core/utils/app_helper.dart';
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
          AvatarImage(
            photoUrl: staff.photoUrl,
            username: staff.fullName,
            onTap: () =>
                context.go('${AppRouterName.staffHistoryTransactionPath}/${AppRouterName.profilePath}', extra: staff),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
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
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: CColors.shadow),
                      ),
                    ),
                    child: TransactionHitoryListTile(
                      enabled: transaction.storeWaste != null && AppHelper.isWithin5Minutes(transaction.createdAt),
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
                        AppHelper.timeAgoFromMillisecond(transaction.createdAt),
                        transaction.storeWaste == null
                            ? '-'
                            : getIt<NumberFormat>().format(transaction.storeWaste!.earnedBalance),
                      ],
                      onTap: () => context.goNamed(AppRouterName.staffEditHistoryName, extra: transaction),
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
    );
  }
}
