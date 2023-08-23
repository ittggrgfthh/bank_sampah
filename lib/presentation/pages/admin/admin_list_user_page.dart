import 'package:another_flushbar/flushbar_helper.dart';
import 'package:bank_sampah/component/widget/avatar_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/button/rounded_button.dart';
import '../../../component/button/rounded_primary_button.dart';
import '../../../component/field/name_field.dart';
import '../../../component/field/password_field.dart';
import '../../../component/field/phone_field.dart';
import '../../../component/field/rtrw_field.dart';
import '../../../component/widget/filter_role_choice_chip.dart';
import '../../../component/widget/roles_choice_chip.dart';
import '../../../component/widget/upload_photo.dart';
import '../../../component/widget/withdraw_balance_list_tile.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/failure_messages.dart';
import '../../../core/constant/theme.dart';
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
                    return _createUserFormModal(context, formKey);
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

  Widget _createUserFormModal(BuildContext context, GlobalKey<FormState> formKey) {
    return BlocProvider(
      create: (context) => getIt<CreateUserFormBloc>(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.95,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Form(
            key: formKey,
            child: ListView(
              controller: scrollController,
              children: <Widget>[
                Text(
                  'Tambah User',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Builder(
                  builder: (context) {
                    final state = context.watch<CreateUserFormBloc>().state;
                    return PhoneField(
                      suffixIcon: state.isPhoneNumberLoading
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Transform.scale(
                                scale: 0.7,
                                child: const CircularProgressIndicator(),
                              ),
                            )
                          : state.isPhoneNumberExists
                              ? const Icon(Icons.error)
                              : null,
                      onChanged: (value) {
                        context.read<CreateUserFormBloc>().add(CreateUserFormEvent.phoneNumberChanged(value));
                      },
                      validator: (_) {
                        return state.phoneNumber.fold(
                          (failure) => failure.message,
                          (_) => null,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<CreateUserFormBloc, CreateUserFormState>(
                  buildWhen: (previous, current) => previous.errorMessagesShown != current.errorMessagesShown,
                  builder: (context, state) {
                    return NameField(
                      onChanged: (value) {
                        context.read<CreateUserFormBloc>().add(CreateUserFormEvent.fullNameChanged(value));
                      },
                      validator: (_) {
                        return context.read<CreateUserFormBloc>().state.fullName.fold(
                              (failure) => failure.message,
                              (_) => null,
                            );
                      },
                    );
                  },
                ),
                BlocBuilder<CreateUserFormBloc, CreateUserFormState>(
                  builder: (context, state) {
                    return PasswordField(
                      onChanged: (value) {
                        context.read<CreateUserFormBloc>().add(CreateUserFormEvent.passwordChanged(value));
                      },
                      validator: (_) {
                        return context.read<CreateUserFormBloc>().state.password.fold(
                              (failure) => failure.message,
                              (_) => null,
                            );
                      },
                    );
                  },
                ),
                Row(
                  children: [
                    SizedBox(
                      width: (MediaQuery.of(context).size.width / 2) - 25,
                      child: Builder(builder: (context) {
                        return RtrwField(
                          label: 'RT',
                          hintText: '005',
                          helperText: '',
                          onChanged: (value) {
                            context.read<CreateUserFormBloc>().add(CreateUserFormEvent.rtChanged(value));
                          },
                        );
                      }),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width / 2) - 25,
                      child: Builder(builder: (context) {
                        return RtrwField(
                          label: 'RW',
                          hintText: '007',
                          helperText: '',
                          onChanged: (value) {
                            context.read<CreateUserFormBloc>().add(CreateUserFormEvent.rwChanged(value));
                          },
                        );
                      }),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Foto  Pengguna',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        UploadPhoto(
                          onTap: () =>
                              context.read<CreateUserFormBloc>().add(const CreateUserFormEvent.imagePickerOpened()),
                        ),
                      ],
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.primary,
                      height: 188,
                      width: 1,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Role',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Builder(builder: (context) {
                          return RoleChoiceChip(
                            onSelected: (selectedRole) {
                              context.read<CreateUserFormBloc>().add(CreateUserFormEvent.roleChanged(selectedRole));
                            },
                          );
                        }),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(color: Theme.of(context).colorScheme.primary, height: 1),
                const SizedBox(height: 20),
                BlocBuilder<CreateUserFormBloc, CreateUserFormState>(
                  buildWhen: (previous, current) => previous.isSubmitting != current.isSubmitting,
                  builder: (context, state) {
                    state.failureOrSuccessOption.fold(
                      () => null,
                      (failureOrSuccess) => failureOrSuccess.fold(
                        (failure) => FlushbarHelper.createError(message: 'Terjadi kesalahan').show(context),
                        (_) {
                          context.pop();
                        },
                      ),
                    );
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 44,
                          width: (MediaQuery.of(context).size.width / 2) - 25,
                          child: RoundedButton(
                            name: "Batal",
                            onPressed: () => Navigator.pop(context),
                            color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
                            selected: false,
                            textColor: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        SizedBox(
                          height: 44,
                          width: (MediaQuery.of(context).size.width / 2) - 25,
                          child: RoundedPrimaryButton(
                            isLoading: state.isSubmitting,
                            buttonName: "Simpan",
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (formKey.currentState!.validate()) {
                                context.read<CreateUserFormBloc>().add(const CreateUserFormEvent.submitButtonPressed());
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
