import 'package:bank_sampah/core/utils/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/button/rounded_primary_button.dart';
import '../../../component/widget/avatar_image.dart';
import '../../../component/widget/custom_list_tile.dart';
import '../../../component/widget/filter_button.dart';
import '../../../component/widget/modal_checkbox.dart';
import '../../../component/widget/modal_radio_button.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/default_data.dart';
import '../../../core/constant/theme.dart';
import '../../../core/routing/router.dart';
import '../../../domain/entities/user.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/filter_user/filter_user_bloc.dart';
import '../../bloc/list_user/list_user_bloc.dart';
import '../../widgets/failure_info.dart';
import '../app/search_user.dart';

class AdminUserListPage extends StatelessWidget {
  const AdminUserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = context.read<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengguna'),
        actions: [
          IconButton(
            onPressed: () {
              final List<User> users = context.read<ListUserBloc>().state.whenOrNull(loadSuccess: (users) => users)!;
              showSearch(context: context, delegate: SearchUser(users: users, isListUser: true));
            },
            icon: const Icon(Icons.search_rounded),
          ),
          Hero(
            tag: 'profile',
            child: AvatarImage(
              photoUrl: admin.photoUrl,
              username: admin.fullName,
              onTap: () => context.goNamed(AppRouterName.profileName),
            ),
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
      body: BlocListener<FilterUserBloc, FilterUserState>(
        listener: (context, state) {
          state.maybeWhen(
            loadSuccess: (filter) {
              context.read<ListUserBloc>().add(ListUserEvent.initialized(filter));
            },
            orElse: () {},
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: BlocBuilder<FilterUserBloc, FilterUserState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loadFailure: (message) {
                      return Wrap(spacing: 5, children: [
                        Text(message),
                        RoundedPrimaryButton(
                          buttonName: 'Refresh filter',
                          onPressed: () {
                            context.read<FilterUserBloc>().add(const FilterUserEvent.loaded());
                          },
                        )
                      ]);
                    },
                    loadSuccess: (filter) {
                      return Wrap(
                        spacing: 5,
                        children: [
                          SizedBox(
                            height: 26,
                            child: FilterButton(
                              backgroundColor: MyTheme.isDarkMode ? CColors.successDark : CColors.successLight,
                              label: filter.role == null
                                  ? 'Semua'
                                  : filter.role![0].toUpperCase() + filter.role!.substring(1),
                              onPressed: () => showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => ModalRadioButton(
                                  initial: filter.role ?? 'semua',
                                  items: const ['semua', 'warga', 'staff', 'admin'],
                                  title: 'Filter User',
                                  onSelectedChanged: (selectedItem) {
                                    context.read<FilterUserBloc>().add(FilterUserEvent.apply(
                                        filter.copyWith(role: selectedItem == 'semua' ? null : selectedItem)));
                                    context.pop();
                                  },
                                ),
                              ),
                            ),
                          ),
                          ...AppHelper.defaultFilterUser(context, filter)
                        ],
                      );
                    },
                    orElse: () => const Wrap(
                      spacing: 5,
                      children: [
                        CircularProgressIndicator(),
                        Text('loading filter'),
                      ],
                    ),
                  );
                },
              ),
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
                        return FailureInfo(
                          description: 'Tidak ada pengguna, ubahlah filternya!',
                          labelButton: 'Reset Default Filter',
                          onPressed: () => context.read<FilterUserBloc>().add(const FilterUserEvent.reset()),
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
                              child: CustomListTile(
                                isListUser: true,
                                user: user,
                                enabled: true,
                                onTap: () => context.goNamed(AppRouterName.adminEditUserName,
                                    pathParameters: {'userId': users[index].id}),
                              ),
                            );
                          });
                    },
                    loadFailure: (_) => FailureInfo(
                      description: 'Terjadi kesalahan tidak terduga!',
                      labelButton: 'Refresh',
                      onPressed: () => context.read<FilterUserBloc>().add(const FilterUserEvent.loaded()),
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
    );
  }
}
