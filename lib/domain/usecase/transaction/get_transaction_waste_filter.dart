import 'package:fpdart/fpdart.dart';

import '../../../../core/failures/failure.dart';
import '../../entities/filter_transaction_waste.dart';
import '../../repositories/transaction_repository.dart';

class GetTransactionWasteFilter {
  const GetTransactionWasteFilter(this._transactionRepository);
  final TransactionRepository _transactionRepository;

  Future<Either<Failure, FilterTransactionWaste>> call() {
    return _transactionRepository.getTransactionWasteFilter();
  }
}
