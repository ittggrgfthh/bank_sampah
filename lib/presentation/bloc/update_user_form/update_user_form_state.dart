part of 'update_user_form_bloc.dart';

@freezed
class UpdateUserFormState with _$UpdateUserFormState {
  const factory UpdateUserFormState({
    required Option<User> user,
    required Option<File> profilePictureOption,
    required Either<ValueFailure<String>, String> phoneNumber,
    required bool isPhoneNumberLoading,
    required bool isPhoneNumberExists,
    required Either<ValueFailure<String>, String> fullName,
    required String role,
    required Either<ValueFailure<String>, String> password,
    required String rt,
    required String rw,
    required bool isSubmitting,
    required bool errorMessagesShown,
    required Option<Either<Failure, User>> failureOrSuccessOption,
    required bool isLoading,
  }) = _UpdateUserFormState;

  factory UpdateUserFormState.initial() => UpdateUserFormState(
        user: none(),
        profilePictureOption: none(),
        phoneNumber: validatePhoneNumber('', false),
        isPhoneNumberLoading: false,
        isPhoneNumberExists: false,
        fullName: validateName(''),
        role: 'warga',
        password: validatePassword('', 8),
        rt: '',
        rw: '',
        isSubmitting: false,
        errorMessagesShown: false,
        failureOrSuccessOption: none(),
        isLoading: false,
      );
}
