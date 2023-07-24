import 'dart:js_interop';

import 'package:bank_sampah/core/utils/exception.dart';

import '../../core/failures/auth_failure.dart';

import '../../domain/entities/user.dart';

import 'package:fpdart/fpdart.dart';

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
      if (userModel.isNull) {
        return none();
      }
      return Option.of(userModel!.toDomain());
    } catch (e) {
      throw LocalStorageException(e.toString());
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithPhoneNumberAndPassword({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final userRemote = await _userRemoteDataSource.getUserByPhoneNumberAndPassword(
        phoneNumber: phoneNumber,
        password: password,
      );

      await _userLocalDataSource.saveLoggedInUser(userRemote);
      return right<AuthFailure, Unit>(unit);
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
