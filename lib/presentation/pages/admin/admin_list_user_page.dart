import 'package:another_flushbar/flushbar_helper.dart';
import 'package:bank_sampah/presentation/bloc/list_user/list_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/field/name_field.dart';
import '../../../component/field/password_field.dart';
import '../../../component/field/phone_field.dart';
import '../../../core/constant/failure_messages.dart';
import '../../../injection.dart';
import '../../bloc/create_user_form/create_user_form_bloc.dart';

class AdminListUserPage extends StatelessWidget {
  const AdminListUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => getIt<CreateUserFormBloc>(),
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
          ),
          floatingActionButton: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.blueGrey[900],
                isScrollControlled: true,
                builder: (context) {
                  return _createUserFormModal(formKey);
                },
              );
            },
            child: const Text("Tambah Pengguna"),
          ),
          body: BlocProvider(
            create: (context) => getIt<ListUserBloc>()..add(const ListUserEvent.initialized()),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  BlocBuilder<ListUserBloc, ListUserState>(
                    builder: (context, state) {
                      return FilterRoleChoiceChip(
                        onSelected: (selectedRole) {
                          context.read<ListUserBloc>().add(ListUserEvent.roleChanged(selectedRole));
                        },
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
                                  return ListTile(
                                    leading: CircleAvatar(
                                      child: Text(
                                        user.fullName == null
                                            ? "X"
                                            : user.fullName![0].toUpperCase() + user.fullName![1].toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    title: Text(user.fullName ?? "Unknown"),
                                    subtitle: Text("+62 ${user.phoneNumber}"),
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
      ),
    );
  }

  BlocProvider<CreateUserFormBloc> _createUserFormModal(GlobalKey<FormState> formKey) {
    return BlocProvider(
      create: (context) => getIt<CreateUserFormBloc>(),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BlocBuilder<CreateUserFormBloc, CreateUserFormState>(
                builder: (context, state) {
                  return PhoneField(
                    suffixIcon: state.isPhoneNumberLoading
                        ? const CircularProgressIndicator()
                        : state.isPhoneNumberExists
                            ? const Icon(Icons.error)
                            : null,
                    onChanged: (value) {
                      context.read<CreateUserFormBloc>().add(CreateUserFormEvent.phoneNumberChanged(value));
                    },
                    validator: (_) {
                      if (state.isPhoneNumberExists) {
                        return 'Nomor telepon sudah digunakan';
                      } else {
                        return context.read<CreateUserFormBloc>().state.phoneNumber.fold(
                              (failure) => failure.message,
                              (_) => null,
                            );
                      }
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
                  return RoleChoiceChip(
                    onSelected: (selectedRole) {
                      context.read<CreateUserFormBloc>().add(CreateUserFormEvent.roleChanged(selectedRole));
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
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
              const SizedBox(height: 16),
              BlocBuilder<CreateUserFormBloc, CreateUserFormState>(
                builder: (context, state) {
                  return PasswordField(
                    onChanged: (value) {
                      context.read<CreateUserFormBloc>().add(CreateUserFormEvent.confirmPasswordChanged(value));
                    },
                    validator: (_) {
                      return context.read<CreateUserFormBloc>().state.isConfirmPasswordValid
                          ? null
                          : "Kata sandi tidak cocok.";
                    },
                    labelText: 'Confirm Password',
                    hintText: 'Confirm Password',
                    textInputAction: TextInputAction.done,
                  );
                },
              ),
              BlocBuilder<CreateUserFormBloc, CreateUserFormState>(
                buildWhen: (previous, current) => previous.isSubmitting != current.isSubmitting,
                builder: (context, state) {
                  String elevatedText = state.isSubmitting ? "..." : "Submit";
                  return ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (formKey.currentState!.validate()) {
                        context.read<CreateUserFormBloc>().add(
                              const CreateUserFormEvent.submitButtonPressed(),
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                    child: Text(elevatedText),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterRoleChoiceChip extends StatefulWidget {
  final Function(String selectedRole)? onSelected;
  const FilterRoleChoiceChip({
    super.key,
    this.onSelected,
  });

  @override
  State<FilterRoleChoiceChip> createState() => _FilterRoleChoiceChipState();
}

class _FilterRoleChoiceChipState extends State<FilterRoleChoiceChip> {
  int _selectedChoice = 0;
  String _selectedRoleChoice = 'warga';

  final roles = [
    'semua',
    'warga',
    'staff',
    'admin',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List<Widget>.generate(
        roles.length,
        (index) => Container(
          child: ChoiceChip(
            label: Text(roles[index]),
            selected: _selectedChoice == index,
            onSelected: (selectedIndex) {
              setState(() {
                _selectedChoice = index;
                _selectedRoleChoice = roles[index];
                widget.onSelected?.call(_selectedRoleChoice);
              });
            },
          ),
        ),
      ),
    );
  }
}

class RoleChoiceChip extends StatefulWidget {
  final Function(String selectedRole)? onSelected;

  const RoleChoiceChip({
    super.key,
    this.onSelected,
  });

  @override
  State<RoleChoiceChip> createState() => _RoleChoiceChipState();
}

class _RoleChoiceChipState extends State<RoleChoiceChip> {
  int _selectedChoice = 0;
  Role _selectedRoleChoice = Role.warga;

  final roles = [
    Role.warga,
    Role.admin,
    Role.staff,
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 30,
      children: List<Widget>.generate(
        roles.length,
        (index) => ChoiceChip(
          label: Text(roles[index].name),
          selected: _selectedChoice == index,
          onSelected: (selectedIndex) {
            setState(() {
              _selectedChoice = index;
              _selectedRoleChoice = roles[index];
              widget.onSelected?.call(_selectedRoleChoice.name);
            });
          },
        ),
      ),
    );
  }
}

enum Role { admin, staff, warga }
