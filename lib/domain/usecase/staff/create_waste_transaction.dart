import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failure.dart';
import '../../entities/transaction_waste.dart';
import '../../repositories/transaction_repository.dart';

class CreateWasteTransaction {
  const CreateWasteTransaction(this._transactionRepository);

  final TransactionRepository _transactionRepository;

  Future<Either<Failure, Unit>> call(TransactionWaste transaction) {
    return _transactionRepository.createTransaction(transaction);
  }
}
