import 'package:another_flushbar/flushbar_helper.dart';
import 'package:bank_sampah/component/widget/dropdown_village.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/button/rounded_button.dart';
import '../../../component/button/rounded_primary_button.dart';
import '../../../component/field/name_field.dart';
import '../../../component/field/password_field.dart';
import '../../../component/field/phone_field.dart';
import '../../../component/field/rtrw_field.dart';
import '../../../component/widget/roles_choice_chip.dart';
import '../../../component/widget/upload_photo.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/theme.dart';
import '../../../injection.dart';
import '../../bloc/create_user_form/create_user_form_bloc.dart';

class AdminCreateUserPage extends StatelessWidget {
  const AdminCreateUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah User'),
      ),
      body: BlocProvider(
        create: (context) => getIt<CreateUserFormBloc>(),
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: <Widget>[
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
              Builder(builder: (context) {
                return DropdownVillage(
                  onChanged: (village) =>
                      context.read<CreateUserFormBloc>().add(CreateUserFormEvent.villageChanged(village)),
                );
              }),
              const SizedBox(height: 20),
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
                      BlocBuilder<CreateUserFormBloc, CreateUserFormState>(
                        builder: (context, state) {
                          return UploadPhoto(
                            file: state.profilePictureOption,
                            onTap: () =>
                                context.read<CreateUserFormBloc>().add(const CreateUserFormEvent.imagePickerOpened()),
                          );
                        },
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
    );
  }
}
