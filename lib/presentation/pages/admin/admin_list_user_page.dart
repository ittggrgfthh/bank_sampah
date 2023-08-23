import 'package:another_flushbar/flushbar_helper.dart';
import 'package:bank_sampah/component/widget/avatar_image.dart';
import 'package:bank_sampah/presentation/pages/admin/admin_create_user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/widget/filter_role_choice_chip.dart';
import '../../../component/widget/withdraw_balance_list_tile.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/failure_messages.dart';
import '../../../core/routing/router.dart';
import '../../../core/utils/currency_converter.dart';
import '../../../injection.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/create_user_form/create_user_form_bloc.dart';
import '../../bloc/list_user/list_user_bloc.dart';

class AdminListUserPage extends StatelessWidget {
  const AdminListUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = context.read<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => getIt<CreateUserFormBloc>(),
      child: BlocProvider(
        create: (context) => getIt<ListUserBloc>()..add(const ListUserEvent.initialized('semua')),
        child: BlocListener<CreateUserFormBloc, CreateUserFormState>(
          listenWhen: (previous, current) => previous.failureOrSuccessOption != current.failureOrSuccessOption,
          listener: (context, state) {
            final errorMessage = state.failureOrSuccessOption.fold(
              () => null,
              (failureOrSucces) => failureOrSucces.fold(
                (failure) => failure.when(
                  timeout: () => FailureMessages.timeout,
                  unexpected: (_, __, ___) => FailureMessages.unexpected,
                ),
                (_) => null,
              ),
            );

            if (errorMessage != null) {
              FlushbarHelper.createError(message: errorMessage).show(context);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Daftar Pengguna'),
              actions: [
                IconButton(icon: const Icon(Icons.notifications_rounded, size: 32), onPressed: () {}),
                AvatarImage(
                  photoUrl: admin.photoUrl,
                  username: admin.fullName,
                  onTap: () => context.go('${AppRouterName.adminListUsersPath}/${AppRouterName.profilePath}'),
                ),
                const SizedBox(width: 15),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return AdminCreateUserPage(formkey: formKey);
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                );
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
                                    trailing: [user.role, CurrencyConverter.intToIDR(user.pointBalance.currentBalance)],
                                    enabled: true,
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
          ),
        ),
      ),
    );
  }
}
