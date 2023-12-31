import 'package:fpdart/fpdart.dart';

import '../failures/value_failure.dart';

Either<ValueFailure<String>, String> validateEmailAddress(String input) {
  const emailRegex = r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
  if (RegExp(emailRegex).hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure(input, message: 'Email tidak valid'));
  }
}

Either<ValueFailure<String>, String> validatePhoneNumber(String input, bool isPhoneNumberExists) {
  const phoneRegex = r"^\d{3}-\d{4}-\d{2,4}$";

  if (RegExp(phoneRegex).hasMatch(input)) {
    if (isPhoneNumberExists) {
      return left(ValueFailure(input, message: 'Nomor telepon sudah digunakan'));
    }
    return right(input);
  } else {
    return left(ValueFailure(input, message: 'Nomor telepon tidak valid'));
  }
}

Either<ValueFailure<String>, String> validatePassword(String input, int minLength) {
  if (input.length >= minLength) {
    return right(input);
  } else {
    return left(ValueFailure(input, message: 'Panjang kata sandi harus >= $minLength'));
  }
}

Either<ValueFailure<String>, String> validateName(String input) {
  const minLength = 3;

  if (input.length >= minLength) {
    return right(input);
  } else {
    return left(ValueFailure(input, message: 'Panjang nama harus >= $minLength'));
  }
}
