import 'package:fpdart/fpdart.dart';

import '../../core/failures/auth_failure.dart';
import '../entities/user.dart';

abstract class AuthFacade {
  // Mendapatkan data pengguna yang sudah register dari shared_preferences
  Future<Option<User>> getSignedInUser();
  // Login/SignIn dengan nomor telepon dan password
  Future<Either<AuthFailure, Unit>> signInWithPhoneNumberAndPassword({
    required String phoneNumber,
    required String password,
  });
  // Logout dengan menghapus data di shared_preferences
  Future<void> signOut();
}
