import 'package:bank_sampah/core/constant/colors.dart';
import 'package:bank_sampah/core/constant/theme.dart';
import 'package:bank_sampah/core/routing/router.dart';
import 'package:bank_sampah/injection.dart';
import 'package:bank_sampah/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:bank_sampah/presentation/bloc/warga_home/warga_home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/widget/avatar_image.dart';

class WargaHomePage extends StatelessWidget {
  const WargaHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final warga = getIt<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Warga'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_rounded, size: 32), onPressed: () {}),
          AvatarImage(
            photoUrl: warga.photoUrl,
            username: warga.fullName,
            onTap: () => context.go('${AppRouterName.wargaHomePath}/${AppRouterName.profilePath}', extra: warga),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: BlocProvider(
        create: (context) => getIt<WargaHomeBloc>()..add(WargaHomeEvent.initialized(warga.id)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            runSpacing: 10,
            children: [
              Container(),
              _buildSaldo(context),
              Text(
                'Total Sampah Terkumpul (900 kg)',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              _buildTotalSampah(context),
              Container(),
              Text(
                'Riwayat',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              _WargaListTile(),
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
  const _WargaListTile({super.key});

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
          '27 November 2023',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              Icons.eco_rounded,
              size: 20,
              color: MyTheme.isDarkMode ? CColors.successDark : CColors.successLight,
            ),
            Text(
              '100kg',
              style: TextStyle(
                color: MyTheme.isDarkMode ? CColors.successDark : CColors.successLight,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.shopping_bag_rounded,
              size: 20,
              color: MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
            ),
            Text(
              '100kg',
              style: TextStyle(
                color: MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Rp221.000',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Staff Ech Ibang',
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
                  child: const AvatarImage(
                    photoUrl: '',
                    username: 'ab',
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
