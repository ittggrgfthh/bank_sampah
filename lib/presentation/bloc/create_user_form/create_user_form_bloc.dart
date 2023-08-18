import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/failures/failure.dart';
import '../../../core/failures/value_failure.dart';
import '../../../core/utils/value_validators.dart';
import '../../../domain/entities/point_balance.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/waste.dart';
import '../../../domain/usecase/create_user.dart';
import '../../../domain/usecase/get_user_by_phone_number.dart';
import '../../../domain/usecase/pick_image.dart';
import '../../../domain/usecase/upload_profile_picture.dart';

part 'create_user_form_event.dart';
part 'create_user_form_state.dart';
part 'create_user_form_bloc.freezed.dart';

class CreateUserFormBloc extends Bloc<CreateUserFormEvent, CreateUserFormState> {
  final PickImage pickImage;
  final CreateUser createUser;
  final UploadProfilePicture uploadProfilePicture;
  final GetUserByPhoneNumber getUserByPhoneNumber;

  CreateUserFormBloc(
    this.pickImage,
    this.createUser,
    this.uploadProfilePicture,
    this.getUserByPhoneNumber,
  ) : super(CreateUserFormState.initial()) {
    on<CreateUserFormEvent>((event, emit) async {
      await event.when(
        imagePickerOpened: () => _handleImagePickerOpened(emit),
        phoneNumberChanged: (phoneNumber) => _handlePhoneNumberChanged(emit, phoneNumber),
        fullNameChanged: (fullName) => _handleFullNameChanged(emit, fullName),
        roleChanged: (role) => _handleRoleChanged(emit, role),
        passwordChanged: (password) => _handlePasswordChanged(emit, password),
        submitButtonPressed: () => _handleSubmitButtonPressed(emit),
      );
    });
  }

  Future<void> _handleImagePickerOpened(Emitter<CreateUserFormState> emit) async {
    final picture = await pickImage();

    final profilePictureOption = state.profilePictureOption.fold(
      () => optionOf(picture),
      (oldPicture) => optionOf(picture ?? oldPicture),
    );

    emit(state.copyWith(profilePictureOption: profilePictureOption));
  }

  Future<void> _handlePhoneNumberChanged(Emitter<CreateUserFormState> emit, String phoneNumber) async {
    if (phoneNumber.length >= 11) {
      emit(state.copyWith(isPhoneNumberLoading: true));
      final failureOrSuccess = await getUserByPhoneNumber(phoneNumber);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(
            isPhoneNumberLoading: false,
            phoneNumber: validatePhoneNumber(phoneNumber, false),
            isPhoneNumberExists: false)),
        (user) => emit(state.copyWith(
            isPhoneNumberLoading: false,
            phoneNumber: validatePhoneNumber(phoneNumber, true),
            isPhoneNumberExists: true)),
      );
    }
  }

  Future<void> _handleFullNameChanged(Emitter<CreateUserFormState> emit, String fullName) async {
    emit(state.copyWith(fullName: validateName(fullName)));
  }

  Future<void> _handleRoleChanged(Emitter<CreateUserFormState> emit, String role) async {
    emit(state.copyWith(role: role));
  }

  Future<void> _handlePasswordChanged(Emitter<CreateUserFormState> emit, String password) async {
    emit(state.copyWith(
      password: validatePassword(password, 8),
    ));
  }

  Future<void> _handleSubmitButtonPressed(Emitter<CreateUserFormState> emit) async {
    final isPhoneNumberValid = state.phoneNumber.isRight();
    final isPasswordValid = state.password.isRight();
    final isFullNameValid = state.fullName.isRight();

    Either<Failure, String>? failureOrPath;
    Either<Failure, User>? failureOrSuccess;
    late User newUser;

    if (isPhoneNumberValid && isPasswordValid && isFullNameValid) {
      emit(state.copyWith(
        isSubmitting: true,
        failureOrSuccessOption: none(),
      ));

      final phoneNumber = state.phoneNumber.getOrElse((_) => '');
      final password = state.password.getOrElse((_) => '');
      final fullName = state.fullName.getOrElse((_) => '');
      final role = state.role;
      final dateNowEpoch = DateTime.now().millisecondsSinceEpoch;

      newUser = User(
        id: "unknown",
        phoneNumber: phoneNumber,
        role: role,
        password: password,
        fullName: fullName,
        photoUrl: null,
        pointBalance: const PointBalance(
          userId: "unknown",
          currentBalance: 0,
          waste: Waste(
            organic: 0,
            inorganic: 0,
          ),
        ),
        rt: "001",
        rw: "001",
        createdAt: dateNowEpoch,
        updatedAt: dateNowEpoch,
      );

      // There is a picture selected
      if (state.profilePictureOption.isSome()) {
        final picture = state.profilePictureOption.toNullable()!;

        failureOrPath = await uploadProfilePicture(
          picture: picture,
          userId: newUser.id,
        );

        // upload failed
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
        newUser = newUser.copyWith(
          photoUrl: failureOrPath.getRight().toNullable(),
        );
      }

      failureOrSuccess = await createUser(newUser);
    }

    emit(state.copyWith(
      isSubmitting: false,
      errorMessagesShown: true,
      failureOrSuccessOption: optionOf(failureOrSuccess),
    ));
  }
}
