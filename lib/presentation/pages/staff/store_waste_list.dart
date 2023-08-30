import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../component/widget/avatar_image.dart';
import '../../../component/widget/withdraw_balance_list_tile.dart';
import '../../../core/constant/colors.dart';
import '../../../core/routing/router.dart';
import '../../../core/utils/date_time_converter.dart';
import '../../../injection.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/list_user/list_user_bloc.dart';
import '../custom_search_delegate.dart';

class StoreWasteListPage extends StatelessWidget {
  const StoreWasteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final staff = context.read<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simpan Sampah'),
        actions: [
          IconButton(
              icon: const Icon(Icons.search_rounded, size: 32),
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              }),
          IconButton(icon: const Icon(Icons.notifications_rounded, size: 32), onPressed: () {}),
          AvatarImage(
            onTap: () =>
                context.go('${AppRouterName.staffWasteTransactionPath}/${AppRouterName.profilePath}', extra: staff),
            photoUrl: staff.photoUrl,
            username: staff.fullName,
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
                    enabled: users[index].lastTransactionEpoch == null ||
                        !DateTimeConverter.isWithin5Minutes(users[index].lastTransactionEpoch ?? 0),
                    title: users[index].fullName ?? 'No Name',
                    subtitle: '+62 ${users[index].phoneNumber}',
                    trailing: ['Saldo', getIt<NumberFormat>().format(users[index].pointBalance.currentBalance)],
                    photoUrl: users[index].photoUrl,
                    onTap: () => context.goNamed(AppRouterName.staffStoreWasteName, extra: users[index]),
                  ),
                ),
              );
            },
            loadFailure: (_) => const Center(
              child: Text('Terjadi kesalahan'),
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
