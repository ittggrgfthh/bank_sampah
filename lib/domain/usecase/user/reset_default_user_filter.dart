import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failure.dart';
import '../../entities/filter_user.dart';
import '../../repositories/user_repository.dart';

class ResetDefaultUserFilter {
  const ResetDefaultUserFilter(this._userRepository);
  final UserRepository _userRepository;

  Future<Either<Failure, FilterUser>> call() {
    return _userRepository.resetDefaultUserFilter();
  }
}
