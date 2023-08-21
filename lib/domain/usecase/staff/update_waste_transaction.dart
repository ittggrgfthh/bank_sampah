import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failure.dart';
import '../../entities/transaction_waste.dart';
import '../../repositories/transaction_repository.dart';

class UpdateWasteTransaction {
  const UpdateWasteTransaction(this._transactionRepository);

  final TransactionRepository _transactionRepository;

  Future<Either<Failure, Unit>> call(TransactionWaste transaction) {
    return _transactionRepository.updateTransaction(transaction);
  }
}
