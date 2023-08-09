import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';
import '../entities/transaction_waste.dart';
import '../entities/user.dart';

abstract class TransactionRepository {
  Future<Either<Failure, Unit>> createTransaction(TransactionWaste transaction);
  Future<Either<Failure, List<TransactionWaste>>> getTransactions();
  Future<Either<Failure, List<TransactionWaste>>> getTransactionsByStaff(User staff);
  Future<Either<Failure, List<TransactionWaste>>> getTransactionsByUser(User user);
}
