import 'package:bank_sampah/component/dummy/dummy_data.dart';
import 'package:bank_sampah/component/widget/withdraw_balance_list_tile.dart';
import 'package:bank_sampah/core/routing/router.dart';
import 'package:bank_sampah/domain/entities/user.dart';
import 'package:bank_sampah/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WithdrawBalance extends StatelessWidget {
  const WithdrawBalance({super.key});

  @override
  Widget build(BuildContext context) {
    final List<User> userDatas = DummyData.dummyUser;
    final staff = context.read<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarik Saldo'),
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded, size: 32), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_rounded, size: 32), onPressed: () {}),
          Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              onTap: () => context.go('${AppRouterName.staffBalanceTransactionPath}/${AppRouterName.profilePath}'),
              child: Ink.image(
                width: 32,
                height: 32,
                image: CachedNetworkImageProvider(staff.photoUrl ??
                    'https://avatars.mds.yandex.net/i?id=1b0ce6ca8b11735031618d51e2a7e336f6d6f7b5-9291521-images-thumbs&n=13'),
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: ListView.builder(
        itemCount: userDatas.length,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          child: WithdrawBalanceListTile(
            photoUrl: userDatas[index].photoUrl,
            title: userDatas[index].fullName ?? 'No Name',
            subtitle: userDatas[index].phoneNumber,
            trailing: 'Rp. 200.000',
            onTap: () => context.goNamed('withdraw-balance-form', extra: userDatas[index]),
          ),
        ),
      ),
    );
  }
}
