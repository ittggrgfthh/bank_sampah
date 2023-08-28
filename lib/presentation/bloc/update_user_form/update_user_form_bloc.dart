import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/failures/failure.dart';
import '../../../core/failures/value_failure.dart';
import '../../../core/utils/value_validators.dart';
import '../../../domain/entities/user.dart';

part 'update_user_form_event.dart';
part 'update_user_form_state.dart';
part 'update_user_form_bloc.freezed.dart';

class UpdateUserFormBloc extends Bloc<UpdateUserFormEvent, UpdateUserFormState> {
  UpdateUserFormBloc() : super(UpdateUserFormState.initial()) {
    on<UpdateUserFormEvent>((event, emit) async {
      await event.when(
        initial: (user) {
          emit(state.copyWith(isLoading: true));
          if (user.photoUrl != null) {
            File profilePicture = File.fromUri(Uri.https(user.photoUrl!));
            emit(state.copyWith(profilePictureOption: optionOf(profilePicture)));
          }
          emit(state.copyWith(
            fullName: validateName(user.fullName!),
            password: validatePassword(user.password, 8),
            phoneNumber: validatePhoneNumber(user.phoneNumber, false),
            role: user.role,
            rt: user.rt,
            rw: user.rw,
            isLoading: false,
          ));
        },
        imagePickerOpened: () {},
        phoneNumberChanged: (phoneNumber) {},
        fullNameChanged: (fullName) {},
        roleChanged: (role) {},
        passwordChanged: (password) {},
        rtChanged: (rt) {},
        rwChanged: (rw) {},
        submitButtonPressed: () {},
      );
    });
  }
}
