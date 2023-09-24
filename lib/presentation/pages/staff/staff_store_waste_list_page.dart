import 'package:bank_sampah/presentation/widgets/failure_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/button/rounded_primary_button.dart';
import '../../../component/widget/avatar_image.dart';
import '../../../component/widget/custom_list_tile.dart';
import '../../../core/constant/colors.dart';
import '../../../core/routing/router.dart';
import '../../../core/utils/app_helper.dart';
import '../../../domain/entities/user.dart';
import '../../bloc/bloc.dart';
import '../app/search_user.dart';

class StaffStoreWasteListPage extends StatelessWidget {
  const StaffStoreWasteListPage({super.key});

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
          Hero(
            tag: 'profile',
            child: AvatarImage(
              onTap: () => context.goNamed(AppRouterName.profileName),
              photoUrl: staff.photoUrl,
              username: staff.fullName,
            ),
          ),
          const SizedBox(width: 15),
        ],
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
                        children: AppHelper.defaultFilterUser(context, filter),
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
                        return FailureInfo(
                          description: 'Tidak ada pengguna, ubahlah filternya!',
                          labelButton: 'Reset Default Filter',
                          onPressed: () => context.read<FilterUserBloc>().add(const FilterUserEvent.reset()),
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
                            onTap: () => context.goNamed(AppRouterName.staffStoreWasteName,
                                pathParameters: {'userId': users[index].id}),
                          ),
                        ),
                      );
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
