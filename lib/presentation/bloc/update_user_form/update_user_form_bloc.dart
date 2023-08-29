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

part 'update_user_form_event.dart';
part 'update_user_form_state.dart';
part 'update_user_form_bloc.freezed.dart';

class UpdateUserFormBloc extends Bloc<UpdateUserFormEvent, UpdateUserFormState> {
  UpdateUserFormBloc() : super(UpdateUserFormState.initial()) {
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
        imagePickerOpened: () async {},
        phoneNumberChanged: (phoneNumber) async {},
        fullNameChanged: (fullName) async {},
        roleChanged: (role) async {},
        passwordChanged: (password) async {},
        rtChanged: (rt) async {},
        rwChanged: (rw) async {},
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
    final tempFile = File('${tempDir.path}/temp_image.jpg');
    await tempFile.writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return tempFile;
  }
}
