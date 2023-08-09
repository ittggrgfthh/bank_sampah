import 'package:bank_sampah/core/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../component/widget/tarik_saldo_list_tile.dart';
import '../../../injection.dart';
import '../../bloc/list_user/list_user_bloc.dart';

class StoreWasteListPage extends StatelessWidget {
  const StoreWasteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simpan Sampah'),
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded, size: 32), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_rounded, size: 32), onPressed: () {}),
          const SizedBox(
            height: 32,
            width: 32,
            child: CircleAvatar(),
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
                  child: TarikSaldoListTile(
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
