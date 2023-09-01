import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';
import '../entities/report.dart';
import '../entities/transaction_waste.dart';

abstract class TransactionRepository {
  Future<Either<Failure, Unit>> createTransaction(TransactionWaste transaction);
  Future<Either<Failure, Unit>> updateTransaction(TransactionWaste transaction);
  Future<Either<Failure, List<TransactionWaste>>> getTransactions();
  Future<Either<Failure, List<TransactionWaste>>> getTransactionsByStaffId(String staffId);
  Future<Either<Failure, List<TransactionWaste>>> getTransactionsByUserId(String userId);
  Future<Either<Failure, List<TransactionWaste>>> getTransactionsByTimeSpan(TimeSpan timeSpan);
  Future<Either<Failure, List<TransactionWaste>>> getTransactionsFilter(Map<String, dynamic> filter);
}
