import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failure.dart';
import '../entities/transaction_waste.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionsFilter {
  const GetTransactionsFilter(this._transactionRepository);
  final TransactionRepository _transactionRepository;

  Future<Either<Failure, List<TransactionWaste>>> call(Map<String, dynamic> filter) {
    return _transactionRepository.getTransactionsFilter(filter);
  }
}
