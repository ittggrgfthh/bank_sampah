import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failure.dart';
import '../entities/filter_transaction_waste.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionsFilter {
  const GetTransactionsFilter(this._transactionRepository);
  final TransactionRepository _transactionRepository;

  Future<Either<Failure, List<Transaction>>> call(FilterTransactionWaste filter) {
    return _transactionRepository.getFilteredTransactions(filter);
  }
}
