import 'package:fpdart/fpdart.dart';

import '../../core/failures/auth_failure.dart';
import '../../core/utils/app_helper.dart';
import '../../core/utils/exception.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_facade.dart';
import '../datasources/user_local_data_source.dart';
import '../datasources/user_remote_data_source.dart';

class AuthFacadeImpl implements AuthFacade {
  final UserRemoteDataSource _userRemoteDataSource;
  final UserLocalDataSource _userLocalDataSource;
  AuthFacadeImpl(this._userRemoteDataSource, this._userLocalDataSource);

  @override
  Future<Option<User>> getSignedInUser() async {
    try {
      final userModel = await _userLocalDataSource.getLoggedInUser();
      return Option.of(userModel!.toDomain());
    } catch (e) {
      return none();
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithPhoneNumberAndPassword({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final result = await _userRemoteDataSource.getUserByPhoneNumber(phoneNumber);

      if (result.password != AppHelper.hashPassword(password)) {
        return left(const AuthFailure.invalidPassword());
      }

      await _userLocalDataSource.saveLoggedInUser(result);
      return right<AuthFailure, Unit>(unit);
    } on AuthException catch (_) {
      return left(const AuthFailure.invalidPhoneNumberOrPassword());
    } catch (e) {
      return left(AuthFailure.unexpected(e.toString()));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _userLocalDataSource.clearLoggedInUser();
    } catch (e) {
      throw LocalStorageException(e.toString());
    }
  }
}
