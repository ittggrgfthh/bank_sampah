import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../../core/failures/failure.dart';
import '../../../core/failures/value_failure.dart';
import '../../../core/utils/value_validators.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecase/get_user_by_phone_number.dart';
import '../../../domain/usecase/pick_image.dart';

part 'update_user_form_event.dart';
part 'update_user_form_state.dart';
part 'update_user_form_bloc.freezed.dart';

class UpdateUserFormBloc extends Bloc<UpdateUserFormEvent, UpdateUserFormState> {
  final PickImage pickImage;
  final GetUserByPhoneNumber getUserByPhoneNumber;

  UpdateUserFormBloc(
    this.pickImage,
    this.getUserByPhoneNumber,
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
                print(phoneNumber);
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
        submitButtonPressed: () async {},
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
    const maxTempFiles = 100; // Set your desired file limit here

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
