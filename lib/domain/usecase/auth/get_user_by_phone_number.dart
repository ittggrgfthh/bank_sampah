import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failure.dart';
import '../../entities/user.dart';
import '../../repositories/user_repository.dart';

class GetUserByPhoneNumber {
  const GetUserByPhoneNumber(this._userRepository);

  final UserRepository _userRepository;

  Future<Either<Failure, User?>> call(String phoneNumber) {
    return _userRepository.getUserByPhoneNumber(phoneNumber);
  }
}
