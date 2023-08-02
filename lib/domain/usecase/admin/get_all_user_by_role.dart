import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failure.dart';
import '../../entities/user.dart';
import '../../repositories/user_repository.dart';

class GetAllUserByRole {
  const GetAllUserByRole(this._userRepository);

  final UserRepository _userRepository;

  Future<Either<Failure, List<User>?>> call(String role) {
    return _userRepository.getAllUserByRole(role);
  }
}
