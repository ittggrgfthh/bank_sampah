import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failure.dart';
import '../../entities/transaction_waste.dart';
import '../../repositories/transaction_repository.dart';

class GetTransactionsByUserId {
  const GetTransactionsByUserId(this._transactionRepository);
  final TransactionRepository _transactionRepository;

  Future<Either<Failure, List<TransactionWaste>>> call(String userId) {
    return _transactionRepository.getTransactionsByUserId(userId);
  }
}
