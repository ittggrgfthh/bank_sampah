import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/button/rounded_primary_button.dart';
import '../../../component/widget/avatar_image.dart';
import '../../../component/widget/custom_list_tile.dart';
import '../../../component/widget/filter_button.dart';
import '../../../component/widget/modal_checkbox.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/default_data.dart';
import '../../../core/constant/theme.dart';
import '../../../core/routing/router.dart';
import '../../../domain/entities/user.dart';
import '../../bloc/bloc.dart';
import '../search_user.dart';

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
            onPressed: () {
              final List<User> users = context.read<ListUserBloc>().state.whenOrNull(loadSuccess: (users) => users)!;
              showSearch(context: context, delegate: SearchUser(users: users, isStoreWaste: true));
            },
            icon: const Icon(Icons.search_rounded),
          ),
          AvatarImage(
            onTap: () => context.goNamed(AppRouterName.profileName),
            photoUrl: staff.photoUrl,
            username: staff.fullName,
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
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
                            label: 'Desa (${filter.villages?.length ?? 0})',
                            onPressed: () => showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => ModalCheckBox(
                                items: DefaultData.village,
                                initial: filter.villages ?? [],
                                title: 'Filter Desa',
                                onSelectedChanged: (value) {
                                  context
                                      .read<FilterUserBloc>()
                                      .add(FilterUserEvent.apply(filter.copyWith(villages: value)));
                                  context
                                      .read<ListUserBloc>()
                                      .add(ListUserEvent.filterChanged(filter.copyWith(villages: value)));
                                  context.pop();
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 26,
                          child: FilterButton(
                            label: 'RT (${filter.rts?.length ?? 0})',
                            onPressed: () => showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => ModalCheckBox(
                                initial: filter.rts ?? [],
                                items: const ['001', '002', '003', '004'],
                                title: 'Filter RT',
                                onSelectedChanged: (value) {
                                  context
                                      .read<FilterUserBloc>()
                                      .add(FilterUserEvent.apply(filter.copyWith(rts: value)));
                                  context
                                      .read<ListUserBloc>()
                                      .add(ListUserEvent.filterChanged(filter.copyWith(rts: value)));
                                  context.pop();
                                },
                              ),
                            ),
                            backgroundColor: MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
                          ),
                        ),
                        SizedBox(
                          height: 26,
                          child: FilterButton(
                            label: 'RW (${filter.rws?.length ?? 0})',
                            onPressed: () => showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => ModalCheckBox(
                                initial: filter.rws ?? [],
                                items: const ['001', '002', '003', '004'],
                                title: 'Filter RW',
                                onSelectedChanged: (value) {
                                  context
                                      .read<FilterUserBloc>()
                                      .add(FilterUserEvent.apply(filter.copyWith(rws: value)));
                                  context
                                      .read<ListUserBloc>()
                                      .add(ListUserEvent.filterChanged(filter.copyWith(rws: value)));
                                  context.pop();
                                },
                              ),
                            ),
                            backgroundColor: MyTheme.isDarkMode ? CColors.dangerDark : CColors.dangerLight,
                          ),
                        ),
                        Container(
                          height: 26,
                          width: 1,
                          color: CColors.shadow,
                        ),
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
                      itemBuilder: (context, index) => Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: CColors.shadow),
                          ),
                        ),
                        child: CustomListTile(
                          isStoreWaste: true,
                          user: users[index],
                          enabled: true,
                          onTap: () => context
                              .goNamed(AppRouterName.staffStoreWasteName, pathParameters: {'userId': users[index].id}),
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
          ),
        ],
      ),
    );
  }
}
