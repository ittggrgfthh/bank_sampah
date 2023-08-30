import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../../core/failures/failure.dart';
import '../../../core/failures/value_failure.dart';
import '../../../core/utils/value_validators.dart';
import '../../../domain/entities/point_balance.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/waste.dart';
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

  UpdateUserFormBloc(
    this.pickImage,
    this.getUserByPhoneNumber,
    this.uploadProfilePicture,
  ) : super(UpdateUserFormState.initial()) {
    on<UpdateUserFormEvent>((event, emit) async {
      await event.when(
        initial: (user) async {
          emit(state.copyWith(isLoading: true));
          if (user.photoUrl != null) {
            File profilePicture = await urlToFile(user.photoUrl!);
            emit(state.copyWith(profilePictureOption: optionOf(profilePicture)));
          }
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
        imagePickerOpened: () async {
          final picture = await pickImage();

          final profilPictureOption = state.profilePictureOption.fold(
            () => optionOf(picture),
            (oldPicture) => optionOf(picture ?? oldPicture),
          );
          emit(state.copyWith(profilePictureOption: profilPictureOption));
        },
        phoneNumberChanged: (phoneNumber) async {
          if (phoneNumber.length >= 11) {
            emit(state.copyWith(isPhoneNumberLoading: true));
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
        },
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
        submitButtonPressed: () async {
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

            updatedUser = User(
              id: user!.id,
              phoneNumber: phoneNumber,
              fullName: fullName,
              role: role,
              password: password,
              village: village,
              pointBalance: PointBalance(
                userId: user.id,
                currentBalance: 0,
                waste: const Waste(
                  organic: 0,
                  inorganic: 0,
                ),
              ),
              rt: rt,
              rw: rw,
              createdAt: user.createdAt,
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
          }

          emit(state.copyWith(
            isSubmitting: false,
            errorMessagesShown: true,
            failureOrSuccessOption: optionOf(failureOrSuccess),
          ));
        },
      );
    });
  }
  Future<File> urlToFile(String imageUrl) async {
    final http.Response responseData = await http.get(Uri.parse(imageUrl));
    Uint8List uint8list = responseData.bodyBytes;
    var buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);

    final tempDir = await getTemporaryDirectory();
    final tempFiles = tempDir.listSync().whereType<File>().toList();
    const maxTempFiles = 10; // Set your desired file limit here

    // Delete older files if the file limit is exceeded
    if (tempFiles.length >= maxTempFiles) {
      tempFiles.sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()));
      final filesToDelete = tempFiles.sublist(0, tempFiles.length - maxTempFiles + 1);
      for (final file in filesToDelete) {
        await file.delete();
      }
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final tempFile = File('${tempDir.path}/temp_image_$timestamp.jpg');

    await tempFile.writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return tempFile;
  }
}
