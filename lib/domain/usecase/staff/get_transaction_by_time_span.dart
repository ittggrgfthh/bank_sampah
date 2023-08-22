import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failure.dart';
import '../../entities/report.dart';
import '../../entities/transaction_waste.dart';
import '../../repositories/transaction_repository.dart';

class GetTransactionsByTimeSpan {
  const GetTransactionsByTimeSpan(this._transactionRepository);
  final TransactionRepository _transactionRepository;

  Future<Either<Failure, List<TransactionWaste>>> call(TimeSpan timeSpan) {
    return _transactionRepository.getTransactionsByTimeSpan(timeSpan);
  }
}
