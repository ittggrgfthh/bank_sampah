import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/constant/firebase_exception_codes.dart';
import '../../core/failures/failure.dart';
import '../../domain/entities/filter_user.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/filter_user_model.dart';
import '../models/user_model.dart';

/// class yang menghubungkan dengan repository yang ada pada domain
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _userRemoteDataSource;
  final UserLocalDataSource _userLocalDataSource;

  UserRepositoryImpl(this._userRemoteDataSource, this._userLocalDataSource);

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
  Future<Either<Failure, User>> updateUser(User user) async {
    try {
      final userModel = await _userRemoteDataSource.updateUser(UserModel.formDomain(user));
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
  Future<Either<Failure, User>> getUserById(String userId) async {
    try {
      final model = await _userRemoteDataSource.getUserById(userId);
      return right(model.toDomain());
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUserByPhoneNumber(String phoneNumber) async {
    try {
      final model = await _userRemoteDataSource.getUserByPhoneNumber(phoneNumber);
      return right(model.toDomain());
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getFilteredUsers(FilterUser filter) async {
    try {
      final result = await _userRemoteDataSource.getFilteredUsers(FilterUserModel.formDomain(filter));
      return right(result.map((userModel) => userModel.toDomain()).toList());
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
  Future<Either<Failure, FilterUser>> getUserFilter() async {
    try {
      final filter = await _userLocalDataSource.getUserFilter();
      if (filter != null) {
        return right(filter.toDomain());
      }
      return left(const Failure.unexpected('User filter not found'));
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveUserFilter(FilterUser filter) async {
    try {
      await _userLocalDataSource.saveUserFilter(FilterUserModel.formDomain(filter));
      return right(unit);
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }
}
