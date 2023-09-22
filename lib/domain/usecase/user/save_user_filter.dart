import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failure.dart';
import '../../entities/filter_user.dart';
import '../../repositories/user_repository.dart';

class SaveUserFilter {
  const SaveUserFilter(this._userRepository);
  final UserRepository _userRepository;

  Future<Either<Failure, Unit>> call(FilterUser filter) {
    return _userRepository.saveUserFilter(filter);
  }
}
