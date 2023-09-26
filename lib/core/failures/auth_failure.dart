import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

@freezed
class AuthFailure with _$AuthFailure {
  const factory AuthFailure.phoneNumberAlreadyInUse() = _PhoneNumberAlreadyInUse;
  const factory AuthFailure.weakPassword() = _WeakPassword;
  const factory AuthFailure.invalidPhoneNumberOrPassword() = _InvalidPhoneNumberOrPassword;
  const factory AuthFailure.invalidPassword() = _InvalidPassword;
  const factory AuthFailure.invalidPhoneNumber() = _InvalidPhoneNumber;
  const factory AuthFailure.timeout() = _Timeout;
  const factory AuthFailure.unexpected(String message) = _Unexpected;
}
