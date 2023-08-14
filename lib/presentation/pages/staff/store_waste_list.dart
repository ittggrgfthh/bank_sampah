import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../component/widget/withdraw_balance_list_tile.dart';
import '../../../core/routing/router.dart';
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
          Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              onTap: () => context.go('${AppRouterName.staffWasteTransactionPath}/${AppRouterName.profilePath}'),
              child: Ink.image(
                width: 32,
                height: 32,
                image: CachedNetworkImageProvider(
                    'https://firebasestorage.googleapis.com/v0/b/banksampah-b3d01.appspot.com/o/profile-picture%2Ffigma-botts.png?alt=media&token=7611d9e3-3664-449e-8b97-feac1556d64c'),
              ),
            ),
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
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  child: WithdrawBalanceListTile(
                    title: users[index].fullName ?? 'No Name',
                    subtitle: '+62 ${users[index].phoneNumber}',
                    trailing: getIt<NumberFormat>().format(users[index].pointBalance.currentBalance),
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
