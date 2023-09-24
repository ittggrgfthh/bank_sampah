part of 'signin_form_bloc.dart';

@freezed
class SignInFormEvent with _$SignInFormEvent {
  const factory SignInFormEvent.phoneNumberChanged(String phoneNumber) = _PhoneNumberChanged;
  const factory SignInFormEvent.passwordChanged(String password) = _PasswordChanged;
  const factory SignInFormEvent.signInButtonPressed() = _SignInButtonPressed;
}
