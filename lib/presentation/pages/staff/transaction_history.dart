import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/widget/avatar_image.dart';
import '../../../component/widget/custom_list_tile.dart';
import '../../../core/constant/colors.dart';
import '../../../core/routing/router.dart';
import '../../../core/utils/app_helper.dart';
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
            onTap: () => context.goNamed(AppRouterName.profileName),
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
                    child: CustomListTile(
                      enabled: transaction.storeWaste != null && AppHelper.isWithin5Minutes(transaction.createdAt),
                      user: transaction.user,
                      transaction: transaction,
                      isTransactionHistory: true,
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
