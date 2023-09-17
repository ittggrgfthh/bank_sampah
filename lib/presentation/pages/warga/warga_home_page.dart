import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/widget/avatar_image.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/theme.dart';
import '../../../core/routing/router.dart';
import '../../../core/utils/app_helper.dart';
import '../../../domain/entities/transaction_waste.dart';
import '../../../injection.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/warga_home/warga_home_bloc.dart';

class WargaHomePage extends StatelessWidget {
  const WargaHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final warga = getIt<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Warga'),
        actions: [
          AvatarImage(
            photoUrl: warga.photoUrl,
            username: warga.fullName,
            onTap: () => context.goNamed(AppRouterName.profileName),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: BlocProvider(
        create: (context) => getIt<WargaHomeBloc>()..add(WargaHomeEvent.initialized(warga.id)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSaldo(context),
              const SizedBox(height: 10),
              BlocBuilder<WargaHomeBloc, WargaHomeState>(
                builder: (context, state) {
                  final totalWaste = state.totalWasteStored;
                  return Text(
                    'Total Sampah Terkumpul ($totalWaste kg)',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildTotalSampah(context),
              const SizedBox(height: 10),
              Text(
                'Riwayat',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              BlocBuilder<WargaHomeBloc, WargaHomeState>(
                builder: (context, state) {
                  final transactions = state.transactionwaste.toNullable();
                  if (transactions != null) {
                    if (transactions.isEmpty) {
                      return const Text('Tidak ada Transaksi');
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          return _WargaListTile(transaction: transactions[index]);
                        },
                      ),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaldo(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.wallet_rounded,
                color: Theme.of(context).colorScheme.background,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                'Saldo',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              )
            ],
          ),
          BlocBuilder<WargaHomeBloc, WargaHomeState>(
            buildWhen: (previous, current) => previous.totalBalance != current.totalBalance,
            builder: (context, state) {
              return Text(
                'Rp${state.totalBalance}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSampah(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MyTheme.isDarkMode ? CColors.successDark : CColors.successLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 5,
                  children: [
                    Icon(
                      Icons.eco_rounded,
                      color: Theme.of(context).colorScheme.background,
                      size: 20,
                    ),
                    Text(
                      'Organik',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                BlocBuilder<WargaHomeBloc, WargaHomeState>(
                  buildWhen: (previous, current) => previous.totalOrganic != current.totalOrganic,
                  builder: (context, state) {
                    return Text(
                      '${state.totalOrganic} Kg',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 5,
                  children: [
                    Icon(
                      Icons.shopping_bag_rounded,
                      color: Theme.of(context).colorScheme.background,
                      size: 20,
                    ),
                    Text(
                      'An-Organik',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                BlocBuilder<WargaHomeBloc, WargaHomeState>(
                  buildWhen: (previous, current) => previous.totalInorganic != current.totalInorganic,
                  builder: (context, state) {
                    return Text(
                      '${state.totalInorganic} Kg',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WargaListTile extends StatelessWidget {
  final TransactionWaste transaction;

  const _WargaListTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CColors.shadow),
      ),
      child: ListTile(
        title: Text(
          AppHelper.millisecondEpochtoString(transaction.createdAt),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Builder(builder: (context) {
          if (transaction.storeWaste != null) {
            final waste = transaction.storeWaste!.waste;
            return Row(
              children: [
                Visibility(
                  visible: waste.organic > 0,
                  child: Row(
                    children: [
                      Icon(
                        Icons.eco_rounded,
                        size: 20,
                        color: MyTheme.isDarkMode ? CColors.successDark : CColors.successLight,
                      ),
                      Text(
                        '${waste.organic}kg',
                        style: TextStyle(
                          color: MyTheme.isDarkMode ? CColors.successDark : CColors.successLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ),
                Visibility(
                  visible: waste.inorganic > 0,
                  child: Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_rounded,
                        size: 20,
                        color: MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
                      ),
                      Text(
                        '${waste.inorganic}kg',
                        style: TextStyle(
                          color: MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Text('Tarik Saldo');
        }),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              transaction.storeWaste != null
                  ? AppHelper.intToIDR(transaction.storeWaste!.earnedBalance)
                  : '-${AppHelper.intToIDR(transaction.withdrawnBalance!.withdrawn)}',
              style: TextStyle(
                color: transaction.storeWaste != null
                    ? Theme.of(context).colorScheme.primary
                    : MyTheme.isDarkMode
                        ? CColors.dangerDark
                        : CColors.dangerLight,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  transaction.staff.fullName!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: CColors.shadow),
                  ),
                  child: AvatarImage(
                    photoUrl: transaction.staff.photoUrl,
                    username: transaction.staff.fullName,
                    size: 16,
                    fontSize: 9,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
