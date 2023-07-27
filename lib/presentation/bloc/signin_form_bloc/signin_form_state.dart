part of 'signin_form_bloc.dart';

@freezed
class SignInFormState with _$SignInFormState {
  const factory SignInFormState({
    required Either<ValueFailure<String>, String> phoneNumber,
    required Either<ValueFailure<String>, String> password,
    required bool isSubmitting,
    required bool errorMessagesShown,
    required Option<Either<AuthFailure, Unit>> authFailureOrSuccessOption,
  }) = _SigninFormState;

  factory SignInFormState.initial() => SignInFormState(
        phoneNumber: validatePhoneNumber(''),
        password: validatePassword('', 8),
        isSubmitting: false,
        errorMessagesShown: false,
        authFailureOrSuccessOption: none(),
      );
}
