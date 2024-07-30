import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failure.dart';
import '../../entities/transaction.dart';
import '../../repositories/transaction_repository.dart';

class GetTransactionsByUserId {
  const GetTransactionsByUserId(this._transactionRepository);
  final TransactionRepository _transactionRepository;

  Future<Either<Failure, List<Transaction>>> call(String userId) {
    return _transactionRepository.getTransactionsByUserId(userId);
  }
}
