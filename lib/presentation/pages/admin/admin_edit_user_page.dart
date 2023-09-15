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
import '../../../component/widget/dropdown_village.dart';
import '../../../component/widget/roles_choice_chip.dart';
import '../../../component/widget/upload_photo.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/default_data.dart';
import '../../../core/constant/theme.dart';
import '../../../injection.dart';
import '../../bloc/list_user/list_user_bloc.dart';
import '../../bloc/update_user_form/update_user_form_bloc.dart';

class AdminEditUserPage extends StatefulWidget {
  final String userId;
  const AdminEditUserPage({super.key, required this.userId});

  @override
  State<AdminEditUserPage> createState() => _AdminEditUserPageState();
}

class _AdminEditUserPageState extends State<AdminEditUserPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rtController = TextEditingController();
  final TextEditingController _rwController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _nameController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: BlocProvider(
        create: (context) => getIt<UpdateUserFormBloc>()..add(UpdateUserFormEvent.initial(widget.userId)),
        child: BlocListener<UpdateUserFormBloc, UpdateUserFormState>(
          listenWhen: (previous, current) => previous.isSubmitting != current.isSubmitting,
          listener: (context, state) {
            state.failureOrSuccessOption.fold(
              () => null,
              (failureOrSuccess) => failureOrSuccess.fold(
                (failure) => FlushbarHelper.createError(message: 'Terjadi Kesalahan').show(context),
                (_) {
                  context.read<ListUserBloc>().add(const ListUserEvent.initialized('semua'));
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
                    String phoneNumber = state.phoneNumber.getOrElse((l) => '0');
                    _phoneNumberController.text = phoneNumber;
                    return PhoneField(
                      controller: _phoneNumberController,
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
                    String fullName = state.fullName.getOrElse((l) => 'kosong');
                    _nameController.text = fullName;
                    return NameField(
                      controller: _nameController,
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
                BlocBuilder<UpdateUserFormBloc, UpdateUserFormState>(
                  buildWhen: (previous, current) => previous.user != current.user,
                  builder: (context, state) {
                    final village = state.user.toNullable()?.village ?? DefaultData.village.first;
                    return DropdownVillage(
                      initial: village,
                      onChanged: (village) =>
                          context.read<UpdateUserFormBloc>().add(UpdateUserFormEvent.villageChanged(village)),
                    );
                  },
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    SizedBox(
                      width: (MediaQuery.of(context).size.width / 2) - 25,
                      child: BlocBuilder<UpdateUserFormBloc, UpdateUserFormState>(
                        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
                        builder: (context, state) {
                          _rtController.text = state.rt;
                          return RtrwField(
                            controller: _rtController,
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
                        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
                        builder: (context, state) {
                          _rwController.text = state.rw;
                          return RtrwField(
                            controller: _rwController,
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
                        BlocBuilder<UpdateUserFormBloc, UpdateUserFormState>(
                          buildWhen: (previous, current) => previous.isLoading != current.isLoading,
                          builder: (context, state) {
                            final role = state.user.toNullable()?.role;
                            if (role == null) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return RoleChoiceChip(
                              initial: role,
                              onSelected: (selectedRole) {
                                context.read<UpdateUserFormBloc>().add(UpdateUserFormEvent.roleChanged(selectedRole));
                              },
                            );
                          },
                        )
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
