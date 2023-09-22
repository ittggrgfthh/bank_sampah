import 'package:fpdart/fpdart.dart';

import '../../../../core/failures/failure.dart';
import '../../entities/filter_transaction_waste.dart';
import '../../repositories/transaction_repository.dart';

class SaveTransactionWasteFilter {
  const SaveTransactionWasteFilter(this._transactionRepository);
  final TransactionRepository _transactionRepository;

  Future<Either<Failure, Unit>> call(FilterTransactionWaste filter) {
    return _transactionRepository.saveTransactionWasteFilter(filter);
  }
}
