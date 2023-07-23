import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/usecase/create_user_profile.dart';
import '../../../domain/usecase/pick_image.dart';
import '../../../domain/usecase/upload_profile_picture.dart';
import '../../../core/failures/failure.dart';
import '../../../core/failures/value_failure.dart';
import '../../../core/utils/value_validators.dart';

part 'profile_setup_bloc.freezed.dart';
part 'profile_setup_event.dart';
part 'profile_setup_state.dart';

class ProfileSetupFormBloc extends Bloc<ProfileSetupFormEvent, ProfileSetupFormState> {
  final PickImage _pickImage;
  final CreateUserProfile _createUserProfile;
  final UploadProfilePicture _uploadProfilePicture;

  ProfileSetupFormBloc(
    this._pickImage,
    this._createUserProfile,
    this._uploadProfilePicture,
  ) : super(ProfileSetupFormState.initial()) {
    on<ProfileSetupFormEvent>((event, emit) async {
      await event.when(
        imagePickerOpened: () => _handleImagePickerOpened(emit),
        nameChanged: (name) => _handleNameChanged(emit, name),
        submitButtonPressed: () => _handleSubmitButtonPressed(emit),
      );
    });
  }

  Future<void> _handleImagePickerOpened(
    Emitter<ProfileSetupFormState> emit,
  ) async {
    final picture = await _pickImage();

    final profilePictureOption = state.profilePictureOption.fold(
      () => optionOf(picture),
      (oldPicture) => optionOf(picture ?? oldPicture),
    );

    emit(state.copyWith(
      profilePictureOption: profilePictureOption,
    ));
  }

  Future<void> _handleNameChanged(
    Emitter<ProfileSetupFormState> emit,
    String name,
  ) async {
    emit(state.copyWith(
      name: validateName(name),
    ));
  }

  Future<void> _handleSubmitButtonPressed(
    Emitter<ProfileSetupFormState> emit,
  ) async {
    final isNameValid = state.name.isRight();
    Either<Failure, String>? failureOrPath;
    Either<Failure, Unit>? failureOrSuccess;
    late User newUser;

    if (isNameValid) {
      emit(state.copyWith(
        isSubmitting: true,
        failureOrSuccessOption: none(),
      ));

      final name = state.name.getOrElse((_) => '');
      const user = User(id: "unknown", phoneNumber: "unknown", role: "warga", password: "unknown");
      newUser = user.copyWith(fullName: name);

      if (state.profilePictureOption.isSome()) {
        final picture = state.profilePictureOption.toNullable()!;

        failureOrPath = await _uploadProfilePicture(
          picture: picture,
          userId: "noting",
        );

        // upload failed
        if (failureOrPath.isLeft()) {
          emit(state.copyWith(
            isSubmitting: false,
            errorMessagesShown: true,
            failureOrSuccessOption: optionOf(
              left<Failure, Unit>(failureOrPath.getLeft().toNullable()!),
            ),
          ));
          return;
        }

        newUser = newUser.copyWith(
          photoUrl: failureOrPath.getRight().toNullable(),
        );
      }

      failureOrSuccess = await _createUserProfile(newUser);
    }

    emit(state.copyWith(
      isSubmitting: false,
      errorMessagesShown: true,
      failureOrSuccessOption: optionOf(failureOrSuccess),
    ));
  }
}
