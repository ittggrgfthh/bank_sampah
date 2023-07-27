import 'dart:async';
import 'dart:io';

import 'package:bank_sampah/data/models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/constant/firebase_exception_codes.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../core/failures/failure.dart';

import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _userRemoteDataSource;

  UserRepositoryImpl(this._userRemoteDataSource);

  @override
  Stream<Either<Failure, User?>> getUserProfile(String userId) async* {
    yield* _userRemoteDataSource
        .getUserProfile(userId)
        .map((userModel) => right<Failure, User?>(userModel?.toDomain()))
        .onErrorReturnWith((error, stackTrace) => left(Failure.unexpected(error.toString())));
  }

  @override
  Future<Either<Failure, User>> createUser(User user) async {
    try {
      final userModel = await _userRemoteDataSource.createUser(UserModel.formDomain(user));
      return right(userModel.toDomain());
    } on FirebaseException catch (e) {
      if (e.code == FirebaseExceptionCodes.unavailable) {
        return left(const Failure.timeout());
      }
      return left(Failure.unexpected(e.toString()));
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createUserProfile(User user) async {
    try {
      await _userRemoteDataSource.createUserProfile(UserModel.formDomain(user));
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.code == FirebaseExceptionCodes.unavailable) {
        return left(const Failure.timeout());
      }
      return left(Failure.unexpected(e.toString()));
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture({required File picture, required String userId}) async {
    try {
      final result = await _userRemoteDataSource.uploadProfilePicture(
        picture: picture,
        userId: userId,
      );
      return right(result);
    } on FirebaseException catch (e) {
      return left(Failure.unexpected(e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, User>> getUserById(String userId) async {
    try {
      final model = await _userRemoteDataSource.getUserById(userId);
      return right(model.toDomain());
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }
}
