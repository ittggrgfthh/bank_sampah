import 'dart:io';

import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> createUser(User user);
  Future<Either<Failure, String>> uploadProfilePicture({
    required File picture,
    required String userId,
  });

  // Old method
  Stream<Either<Failure, User?>> getUserProfile(String userId);
  Future<Either<Failure, Unit>> createUserProfile(User user);
}
