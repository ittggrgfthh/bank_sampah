import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/widget/avatar_image.dart';
import '../../../component/widget/filter_role_choice_chip.dart';
import '../../../component/widget/withdraw_balance_list_tile.dart';
import '../../../core/constant/colors.dart';
import '../../../core/routing/router.dart';
import '../../../core/utils/app_helper.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/list_user/list_user_bloc.dart';

class AdminListUserPage extends StatelessWidget {
  const AdminListUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = context.read<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengguna'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_rounded, size: 32), onPressed: () {}),
          AvatarImage(
            photoUrl: admin.photoUrl,
            username: admin.fullName,
            onTap: () => context.go('${AppRouterName.adminListUsersPath}/${AppRouterName.profilePath}', extra: admin),
          ),
          const SizedBox(width: 15),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(AppRouterName.adminCreateUserName);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.background,
        child: const Icon(Icons.add_rounded, size: 32),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<ListUserBloc, ListUserState>(
            builder: (context, state) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: FilterRoleChoiceChip(
                  onSelected: (selectedRole) {
                    context.read<ListUserBloc>().add(ListUserEvent.roleChanged(selectedRole));
                  },
                ),
              );
            },
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: BlocBuilder<ListUserBloc, ListUserState>(
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
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: CColors.shadow),
                              ),
                            ),
                            child: WithdrawBalanceListTile(
                              photoUrl: user.photoUrl,
                              title: user.fullName ?? 'No Name',
                              subtitle: '+62 ${user.phoneNumber}',
                              trailing: [user.role, AppHelper.intToIDR(user.pointBalance.currentBalance)],
                              enabled: true,
                              onTap: () => context.goNamed(AppRouterName.adminEditUserName, extra: user),
                            ),
                          );
                        });
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
          ),
        ],
      ),
    );
  }
}
