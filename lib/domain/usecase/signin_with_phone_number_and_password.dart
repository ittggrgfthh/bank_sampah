import 'package:fpdart/fpdart.dart';

import '../../core/failures/auth_failure.dart';
import '../repositories/auth_facade.dart';

class SigninWithPhoneNumberAndPassword {
  const SigninWithPhoneNumberAndPassword(this.authFacade);

  final AuthFacade authFacade;

  Future<Either<AuthFailure, Unit>> call({
    required String phoneNumber,
    required String password,
  }) {
    return authFacade.signInWithPhoneNumberAndPassword(
      phoneNumber: phoneNumber,
      password: password,
    );
  }
}
