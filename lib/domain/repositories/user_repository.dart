import 'dart:io';

import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';
import '../entities/filter_user.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> createUser(User user);
  Future<Either<Failure, String>> uploadProfilePicture({
    required File picture,
    required String userId,
  });
  Future<Either<Failure, User>> getUserById(String userId);
  Future<Either<Failure, User>> getUserByPhoneNumber(String phoneNumber);
  Future<Either<Failure, User>> updateUser(User user);

  /// mendapatkan users yang difilter
  Future<Either<Failure, List<User>>> getFilteredUsers(FilterUser filter);

  /// mendapatkan filter user
  Future<Either<Failure, FilterUser>> getUserFilter();
  Future<Either<Failure, Unit>> saveUserFilter(FilterUser filter);
  Future<Either<Failure, FilterUser>> resetDefaultUserFilter();
}
