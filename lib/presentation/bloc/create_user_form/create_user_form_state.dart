part of 'create_user_form_bloc.dart';

@freezed
class CreateUserFormState with _$CreateUserFormState {
  const factory CreateUserFormState({
    required Option<File> profilePictureOption,
    required Either<ValueFailure<String>, String> phoneNumber,
    required bool isPhoneNumberLoading,
    required bool isPhoneNumberExists,
    required Either<ValueFailure<String>, String> fullName,
    required String role,
    required Either<ValueFailure<String>, String> password,
    required String confirmPassword,
    required bool isConfirmPasswordValid,
    required bool isSubmitting,
    required bool errorMessagesShown,
    required Option<Either<Failure, User>> failureOrSuccessOption,
  }) = _CreateUserFormState;

  factory CreateUserFormState.initial() => CreateUserFormState(
        profilePictureOption: none(),
        phoneNumber: validatePhoneNumber(''),
        isPhoneNumberLoading: false,
        isPhoneNumberExists: false,
        fullName: validateName(''),
        role: 'warga',
        password: validatePassword('', 8),
        confirmPassword: '',
        isConfirmPasswordValid: true,
        isSubmitting: false,
        errorMessagesShown: false,
        failureOrSuccessOption: none(),
      );
}
