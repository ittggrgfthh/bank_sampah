import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failure.dart';
import '../../entities/filter_user.dart';
import '../../entities/user.dart';
import '../../repositories/user_repository.dart';

class GetFilteredUsers {
  const GetFilteredUsers(this._userRepository);

  final UserRepository _userRepository;

  Future<Either<Failure, List<User>>> call(FilterUser filterUser) {
    return _userRepository.getFilteredUsers(filterUser);
  }
}
