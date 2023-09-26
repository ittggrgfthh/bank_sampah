import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/button/rounded_primary_button.dart';
import '../../../component/widget/avatar_image.dart';
import '../../../component/widget/custom_list_tile.dart';
import '../../../component/widget/filter_button.dart';
import '../../../component/widget/modal_date_time.dart';
import '../../../core/constant/colors.dart';
import '../../../core/routing/router.dart';
import '../../../core/utils/app_helper.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/filter_transaction_waste/filter_transaction_waste_bloc.dart';
import '../../bloc/transaction_history/transaction_history_bloc.dart';
import '../../widgets/failure_info.dart';

class StaffTransactionHistoryPage extends StatelessWidget {
  const StaffTransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final staff = context.read<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
    context.read<FilterTransactionWasteBloc>().add(const FilterTransactionWasteEvent.loaded());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        actions: [
          Hero(
            tag: 'profile',
            child: AvatarImage(
              photoUrl: staff.photoUrl,
              username: staff.fullName,
              onTap: () => context.goNamed(AppRouterName.profileName),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: BlocListener<FilterTransactionWasteBloc, FilterTransactionWasteState>(
        listener: (context, state) {
          state.maybeWhen(
            loadSuccess: (filter) =>
                context.read<TransactionHistoryBloc>().add(TransactionHistoryEvent.filterChanged(filter)),
            orElse: () {},
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.horizontal,
              child: BlocBuilder<FilterTransactionWasteBloc, FilterTransactionWasteState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loadFailure: (message) {
                      return Wrap(spacing: 5, children: [
                        Text(message),
                        RoundedPrimaryButton(
                          buttonName: 'Refresh filter',
                          onPressed: () {
                            context.read<FilterTransactionWasteBloc>().add(const FilterTransactionWasteEvent.loaded());
                          },
                        )
                      ]);
                    },
                    loadSuccess: (filter) {
                      DateTime now = DateTime.now();
                      String startEpoch = AppHelper.millisecondEpochtoString(filter.startEpoch ?? 0);
                      String endEpoch = AppHelper.millisecondEpochtoString(filter.endEpoch ?? 1);
                      return Wrap(
                        spacing: 5,
                        children: [
                          SizedBox(
                            height: 26,
                            child: FilterButton(
                              label: '$startEpoch - $endEpoch',
                              onPressed: () => showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => ModalDateTime(
                                  startDate: filter.startEpoch ?? now.millisecondsSinceEpoch,
                                  endDate: filter.endEpoch ?? now.millisecondsSinceEpoch,
                                  title: 'Filter Waktu',
                                  onSelectedChanged: (startEpoch, endEpoch) {
                                    final newFilter = filter.copyWith(startEpoch: startEpoch, endEpoch: endEpoch);
                                    context
                                        .read<FilterTransactionWasteBloc>()
                                        .add(FilterTransactionWasteEvent.apply(newFilter));
                                    context.pop();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    orElse: () => const Wrap(
                      spacing: 5,
                      children: [
                        CircularProgressIndicator(),
                        Text('loading filter'),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loadSuccess: (transactions) {
                      if (transactions.isEmpty) {
                        return FailureInfo(
                          description: 'Tidak ada transaksi, coba ubah filternya dulu!',
                          labelButton: 'Reset Default Filter',
                          onPressed: () =>
                              context.read<FilterTransactionWasteBloc>().add(const FilterTransactionWasteEvent.reset()),
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
                              enabled:
                                  transaction.storeWaste != null && AppHelper.isWithin5Minutes(transaction.createdAt),
                              user: transaction.user,
                              transaction: transaction,
                              isTransactionHistory: true,
                              onTap: () => context.goNamed(AppRouterName.staffEditHistoryName, extra: transaction),
                            ),
                          );
                        },
                      );
                    },
                    loadFailure: (_) => FailureInfo(
                      description: 'Terjadi kesalahan tak terduga seperti jaringan.',
                      labelButton: 'Refresh',
                      onPressed: () =>
                          context.read<FilterTransactionWasteBloc>().add(const FilterTransactionWasteEvent.loaded()),
                    ),
                    orElse: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
