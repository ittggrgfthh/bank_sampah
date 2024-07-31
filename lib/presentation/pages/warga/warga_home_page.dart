import 'package:bank_sampah/component/dummy/dummy_data.dart';
import 'package:bank_sampah/domain/entities/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/widget/avatar_image.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/theme.dart';
import '../../../core/routing/router.dart';
import '../../../core/utils/app_helper.dart';
import '../../../injection.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/warga_home/warga_home_bloc.dart';

class WargaHomePage extends StatelessWidget {
  const WargaHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final warga = getIt<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
    List<Transaction> transaction = DummyData.dummyTransaction;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Warga'),
        actions: [
          Hero(
            tag: 'profile',
            child: AvatarImage(
              photoUrl: warga.photoUrl,
              username: warga.fullName,
              onTap: () => context.goNamed(AppRouterName.profileName),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: BlocProvider(
        create: (context) => getIt<WargaHomeBloc>()..add(WargaHomeEvent.initialized(warga.id.toString())),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              BlocBuilder<WargaHomeBloc, WargaHomeState>(
                builder: (context, state) {
                  const totalWaste = 0;
                  return Text(
                    'Total Sampah Terkumpul ($totalWaste kg)',
                    style: TextStyle(
                      color: MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
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
                  color: MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return _WargaListTile(transaction: transaction[index]);
                  },
                  itemCount: transaction.length,
                ),
              ),
            ],
          ),
        ),
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
                      color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
                      size: 20,
                    ),
                    Text(
                      'Organik',
                      style: TextStyle(
                        color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                BlocBuilder<WargaHomeBloc, WargaHomeState>(
                  builder: (context, state) {
                    return Text(
                      '0 Kg',
                      style: TextStyle(
                        color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
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
                      color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
                      size: 20,
                    ),
                    Text(
                      'An-Organik',
                      style: TextStyle(
                        color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                BlocBuilder<WargaHomeBloc, WargaHomeState>(
                  builder: (context, state) {
                    return Text(
                      '0 Kg',
                      style: TextStyle(
                        color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
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
  final Transaction transaction;

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
            color: MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Builder(builder: (context) {
          return Row(
            children: [
              Visibility(
                visible: true,
                child: Row(
                  children: [
                    Icon(
                      Icons.eco_rounded,
                      size: 20,
                      color: MyTheme.isDarkMode ? CColors.successDark : CColors.successLight,
                    ),
                    Text(
                      '0kg',
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
                visible: true,
                child: Row(
                  children: [
                    Icon(
                      Icons.shopping_bag_rounded,
                      size: 20,
                      color: MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
                    ),
                    Text(
                      '0kg',
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
        }),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Rp. 0',
              style: TextStyle(
                color: MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  transaction.admin.fullName.toString(),
                  style: TextStyle(
                    color: MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
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
                    username: 'MI',
                    photoUrl: '',
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
