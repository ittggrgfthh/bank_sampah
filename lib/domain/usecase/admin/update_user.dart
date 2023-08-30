import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failure.dart';
import '../../entities/user.dart';
import '../../repositories/user_repository.dart';

class UpdateUser {
  const UpdateUser(this._userRepository);

  final UserRepository _userRepository;

  Future<Either<Failure, User>> call(User user) {
    return _userRepository.updateUser(user);
  }
}
