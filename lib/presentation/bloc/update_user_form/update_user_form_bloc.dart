import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/failures/failure.dart';
import '../../../core/failures/value_failure.dart';
import '../../../core/utils/app_helper.dart';
import '../../../core/utils/value_validators.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecase/admin/update_user.dart';
import '../../../domain/usecase/auth/get_user_by_id.dart';
import '../../../domain/usecase/auth/get_user_by_phone_number.dart';
import '../../../domain/usecase/pick_image.dart';
import '../../../domain/usecase/upload_profile_picture.dart';

part 'update_user_form_bloc.freezed.dart';
part 'update_user_form_event.dart';
part 'update_user_form_state.dart';

class UpdateUserFormBloc extends Bloc<UpdateUserFormEvent, UpdateUserFormState> {
  final PickImage pickImage;
  final GetUserByPhoneNumber getUserByPhoneNumber;
  final UploadProfilePicture uploadProfilePicture;
  final UpdateUser updateUser;
  final GetUserById getUserById;

  UpdateUserFormBloc(
    this.pickImage,
    this.getUserByPhoneNumber,
    this.uploadProfilePicture,
    this.updateUser,
    this.getUserById,
  ) : super(UpdateUserFormState.initial()) {
    on<UpdateUserFormEvent>((event, emit) async {
      await event.when(
        initial: (userId) async {
          emit(state.copyWith(isLoading: true));
          final failureOrSuccess = await getUserById(userId);

          failureOrSuccess.fold(
            (failure) => emit(state.copyWith(isLoading: false)),
            (user) async {
              emit(state.copyWith(
                fullName: validateName(user.fullName!),
                password: validatePassword(user.password, 8),
                phoneNumber: validatePhoneNumber(user.phoneNumber, false),
                role: user.role,
                rt: user.rt,
                rw: user.rw,
                village: user.village ?? '',
                user: optionOf(user),
                isLoading: false,
              ));
            },
          );
        },
        imagePickerOpened: () async {
          final picture = await pickImage();

          final profilPictureOption = state.profilePictureOption.fold(
            () => optionOf(picture),
            (oldPicture) => optionOf(picture ?? oldPicture),
          );
          emit(state.copyWith(profilePictureOption: profilPictureOption));
        },
        phoneNumberChanged: (phoneNumber) => _handlePhoneNumberChanged(emit, phoneNumber),
        fullNameChanged: (fullName) async {
          emit(state.copyWith(fullName: validateName(fullName)));
        },
        roleChanged: (role) async {
          emit(state.copyWith(role: role));
        },
        passwordChanged: (password) async {
          emit(state.copyWith(password: validatePassword(password, 8)));
        },
        rtChanged: (rt) async {
          emit(state.copyWith(rt: rt));
        },
        rwChanged: (rw) async {
          emit(state.copyWith(rw: rw));
        },
        villageChanged: (village) {
          emit(state.copyWith(village: village));
        },
        submitButtonPressed: () => _handleSubmitButtonPressed(emit),
      );
    });
  }

  Future<void> _handlePhoneNumberChanged(Emitter<UpdateUserFormState> emit, String phoneNumber) async {
    if (phoneNumber.length >= 11) {
      emit(state.copyWith(isPhoneNumberLoading: true));

      final user = state.user.toNullable();
      if (user != null && user.phoneNumber == phoneNumber) {
        return emit(state.copyWith(
          isPhoneNumberLoading: false,
          phoneNumber: validatePhoneNumber(phoneNumber, false),
          isPhoneNumberExists: false,
        ));
      }

      // print('phoneNumber: $phoneNumber');
      final failureOrSuccess = await getUserByPhoneNumber(phoneNumber);

      failureOrSuccess.fold(
        (failure) {
          emit(state.copyWith(
              isPhoneNumberLoading: false,
              phoneNumber: validatePhoneNumber(phoneNumber, false),
              isPhoneNumberExists: false));
        },
        (user) {
          emit(state.copyWith(
              isPhoneNumberLoading: false,
              phoneNumber: validatePhoneNumber(phoneNumber, true),
              isPhoneNumberExists: true));
        },
      );
    }
  }

  Future<void> _handleSubmitButtonPressed(Emitter<UpdateUserFormState> emit) async {
    final isPhoneNumberValid = state.phoneNumber.isRight();
    final isPasswordValid = state.password.isRight();
    final isFullNameValid = state.fullName.isRight();

    Either<Failure, String>? failureOrPath;
    Either<Failure, User>? failureOrSuccess;
    late User updatedUser;

    if (isPhoneNumberValid && isPasswordValid && isFullNameValid) {
      emit(state.copyWith(isSubmitting: true, failureOrSuccessOption: none()));

      final phoneNumber = state.phoneNumber.getOrElse((l) => '');
      final fullName = state.fullName.getOrElse((l) => '');
      final password = state.password.getOrElse((l) => '');
      final role = state.role;
      final rt = state.rt;
      final rw = state.rw;
      final village = state.village;
      final user = state.user.toNullable();
      final dateNowEpoch = DateTime.now().millisecondsSinceEpoch;

      updatedUser = user!.copyWith(
        phoneNumber: phoneNumber,
        fullName: fullName,
        password: user.password != password ? AppHelper.hashPassword(password) : password,
        role: role,
        rt: rt,
        rw: rw,
        village: village,
        updatedAt: dateNowEpoch,
      );

      if (state.profilePictureOption.isSome()) {
        final picture = state.profilePictureOption.toNullable()!;

        failureOrPath = await uploadProfilePicture(
          picture: picture,
          userId: user.id,
        );

        if (failureOrPath.isLeft()) {
          emit(state.copyWith(
            isSubmitting: false,
            errorMessagesShown: true,
            failureOrSuccessOption: optionOf(
              left<Failure, User>(failureOrPath.getLeft().toNullable()!),
            ),
          ));
          return;
        }
        updatedUser = updatedUser.copyWith(photoUrl: failureOrPath.getRight().toNullable());
      }
      //send user to update
      failureOrSuccess = await updateUser(updatedUser);
    }

    emit(state.copyWith(
      isSubmitting: false,
      errorMessagesShown: true,
      failureOrSuccessOption: optionOf(failureOrSuccess),
    ));
  }
}
