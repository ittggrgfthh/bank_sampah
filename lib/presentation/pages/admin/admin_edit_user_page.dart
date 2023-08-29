import 'package:another_flushbar/flushbar_helper.dart';
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
import '../../../domain/entities/user.dart';
import '../../../injection.dart';
import '../../bloc/update_user_form/update_user_form_bloc.dart';

class AdminEditUserPage extends StatelessWidget {
  final User user;
  const AdminEditUserPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: BlocProvider(
        create: (context) => getIt<UpdateUserFormBloc>()..add(UpdateUserFormEvent.initial(user)),
        child: BlocListener<UpdateUserFormBloc, UpdateUserFormState>(
          listener: (context, state) {
            state.failureOrSuccessOption.fold(
              () => null,
              (failureOrSuccess) => failureOrSuccess.fold(
                (failure) => FlushbarHelper.createError(message: 'Terjadi Kesalahan').show(context),
                (_) {
                  context.read<UpdateUserFormBloc>().add(UpdateUserFormEvent.initial(user));
                  context.pop();
                },
              ),
            );
          },
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: <Widget>[
                const SizedBox(height: 10),
                BlocBuilder<UpdateUserFormBloc, UpdateUserFormState>(
                  buildWhen: (previous, current) => previous.isLoading != current.isLoading,
                  builder: (context, state) {
                    final TextEditingController phoneNumberController = TextEditingController();
                    String phoneNumber = state.phoneNumber.getOrElse((l) => '0');
                    phoneNumberController.text = phoneNumber;
                    return PhoneField(
                      controller: phoneNumberController,
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
                        context.read<UpdateUserFormBloc>().add(UpdateUserFormEvent.phoneNumberChanged(value));
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
                BlocBuilder<UpdateUserFormBloc, UpdateUserFormState>(
                  buildWhen: (previous, current) => previous.isLoading != current.isLoading,
                  builder: (context, state) {
                    final TextEditingController nameController = TextEditingController();
                    String fullName = state.fullName.getOrElse((l) => 'kosong');
                    nameController.text = fullName;
                    return NameField(
                      controller: nameController,
                      onChanged: (value) {
                        context.read<UpdateUserFormBloc>().add(UpdateUserFormEvent.fullNameChanged(value));
                      },
                      validator: (_) {
                        return context.read<UpdateUserFormBloc>().state.fullName.fold(
                              (failure) => failure.message,
                              (_) => null,
                            );
                      },
                    );
                  },
                ),
                BlocBuilder<UpdateUserFormBloc, UpdateUserFormState>(
                  builder: (context, state) {
                    return PasswordField(
                      onChanged: (value) {
                        context.read<UpdateUserFormBloc>().add(UpdateUserFormEvent.passwordChanged(value));
                      },
                      validator: (_) {
                        return context.read<UpdateUserFormBloc>().state.password.fold(
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
                      child: BlocBuilder<UpdateUserFormBloc, UpdateUserFormState>(
                        builder: (context, state) {
                          final TextEditingController rtController = TextEditingController();
                          rtController.text = state.rt;
                          return RtrwField(
                            controller: rtController,
                            label: 'RT',
                            hintText: '005',
                            helperText: '',
                            onChanged: (value) {
                              context.read<UpdateUserFormBloc>().add(UpdateUserFormEvent.rtChanged(value));
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width / 2) - 25,
                      child: BlocBuilder<UpdateUserFormBloc, UpdateUserFormState>(
                        builder: (context, state) {
                          final TextEditingController rwController = TextEditingController();
                          rwController.text = state.rw;
                          return RtrwField(
                            controller: rwController,
                            label: 'RW',
                            hintText: '007',
                            helperText: '',
                            onChanged: (value) {
                              context.read<UpdateUserFormBloc>().add(UpdateUserFormEvent.rwChanged(value));
                            },
                          );
                        },
                      ),
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
                        BlocBuilder<UpdateUserFormBloc, UpdateUserFormState>(
                          builder: (context, state) {
                            return UploadPhoto(
                              file: state.profilePictureOption,
                              onTap: () =>
                                  context.read<UpdateUserFormBloc>().add(const UpdateUserFormEvent.imagePickerOpened()),
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
                            initial: user.role,
                            onSelected: (selectedRole) {
                              context.read<UpdateUserFormBloc>().add(UpdateUserFormEvent.roleChanged(selectedRole));
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
                BlocBuilder<UpdateUserFormBloc, UpdateUserFormState>(
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
                                context.read<UpdateUserFormBloc>().add(const UpdateUserFormEvent.submitButtonPressed());
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
