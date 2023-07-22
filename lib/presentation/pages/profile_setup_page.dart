import 'dart:io';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../constant/colors.dart';
import '../../constant/failure_messages.dart';
import '../../injection.dart';
import '../bloc/profile_setup_form_bloc/profile_setup_bloc.dart';

class ProfileSetupPage extends StatelessWidget {
  const ProfileSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileSetupFormBloc>(),
      child: BlocListener<ProfileSetupFormBloc, ProfileSetupFormState>(
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
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profil'),
              leading: Center(
                  child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Kembali'),
              )),
            ),
            body: const _ProfileSetupPageBody(),
            bottomSheet: BlocBuilder<ProfileSetupFormBloc, ProfileSetupFormState>(
              buildWhen: (previous, current) => previous.isSubmitting != current.isSubmitting,
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    child: const Text("Simpan"),
                    onPressed: () =>
                        context.read<ProfileSetupFormBloc>().add(const ProfileSetupFormEvent.submitButtonPressed()),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileSetupPageBody extends StatelessWidget {
  const _ProfileSetupPageBody();

  Widget _buildAvatar(
    BuildContext context,
    ProfileSetupFormState state,
  ) {
    final width = MediaQuery.of(context).size.width;
    final radius = 0.25 * width;

    return Padding(
      padding: EdgeInsets.only(top: ((width - (radius * 2)) / 4) - 16),
      child: CircleAvatar(
        backgroundColor: CColors.info,
        foregroundImage: state.profilePictureOption.isSome()
            ? FileImage(state.profilePictureOption.getOrElse(() => File('')))
            : null,
        radius: radius,
        child: state.profilePictureOption.isNone()
            ? Text(
                'B',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 0.5 * radius,
                  color: CColors.onInfo,
                ),
              )
            : null,
      ),
    );
  }

  void _openImagePicker(BuildContext context) {
    context.read<ProfileSetupFormBloc>().add(const ProfileSetupFormEvent.imagePickerOpened());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          children: [
            // Avatar
            GestureDetector(
              onTap: () => _openImagePicker(context),
              child: BlocBuilder<ProfileSetupFormBloc, ProfileSetupFormState>(
                buildWhen: (previous, current) => previous.profilePictureOption != current.profilePictureOption,
                builder: _buildAvatar,
              ),
            ),
            Container(
              height: 16,
            ),
            // Change photo button
            ElevatedButton(
              child: const Text("Ubah Foto"),
              onPressed: () => _openImagePicker(context),
            ),
            Container(
              height: 32,
            ),
            BlocBuilder<ProfileSetupFormBloc, ProfileSetupFormState>(
              buildWhen: (previous, current) => previous.errorMessagesShown != current.errorMessagesShown,
              builder: (context, state) {
                return TextFormField(
                  autovalidateMode: state.errorMessagesShown ? AutovalidateMode.always : AutovalidateMode.disabled,
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  onChanged: (name) {
                    context.read<ProfileSetupFormBloc>().add(ProfileSetupFormEvent.nameChanged(name));
                  },
                  validator: (_) {
                    return context.read<ProfileSetupFormBloc>().state.name.fold(
                          (failure) => failure.message,
                          (_) => null,
                        );
                  },
                );
              },
            ),
            Container(
              height: 16,
            ),
            const Text(
              'Kamu bisa isi dengan nama lengkap atau panggilanmu.\n'
              'Nama ini akan ditampilkan ke barbershop yang kamu pesan.',
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}
