import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failure.dart';
import '../../entities/user.dart';
import '../../repositories/user_repository.dart';

class GetUserById {
  const GetUserById(this._userRepository);

  final UserRepository _userRepository;

  Future<Either<Failure, User>> call(String userId) {
    return _userRepository.getUserById(userId);
  }
}
