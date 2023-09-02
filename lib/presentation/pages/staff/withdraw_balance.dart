import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/widget/avatar_image.dart';
import '../../../component/widget/withdraw_balance_list_tile.dart';
import '../../../core/constant/colors.dart';
import '../../../core/routing/router.dart';
import '../../../core/utils/app_helper.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/list_user/list_user_bloc.dart';

class WithdrawBalance extends StatelessWidget {
  const WithdrawBalance({super.key});

  @override
  Widget build(BuildContext context) {
    final staff = context.read<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarik Saldo'),
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
      body: BlocBuilder<ListUserBloc, ListUserState>(
        builder: (context, state) {
          return state.maybeWhen(
            loadSuccess: (users) {
              if (users.isEmpty) {
                return const Center(
                  child: Text('Tidak ada pengguna'),
                );
              }
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) => Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: CColors.shadow),
                    ),
                  ),
                  child: WithdrawBalanceListTile(
                    photoUrl: users[index].photoUrl,
                    title: users[index].fullName ?? 'No Name',
                    subtitle: '+62 ${users[index].phoneNumber}',
                    trailing: ['Saldo', AppHelper.intToIDR(users[index].pointBalance.currentBalance)],
                    onTap: () => context.goNamed(AppRouterName.staffWithdrawName, extra: users[index]),
                    enabled: users[index].pointBalance.currentBalance > 0 &&
                        (users[index].lastTransactionEpoch == null ||
                            !AppHelper.isWithin5Minutes(users[index].lastTransactionEpoch ?? 0)),
                  ),
                ),
              );
            },
            orElse: () => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
