import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';
import '../entities/filter_transaction_waste.dart';
import '../entities/report.dart';
import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, Unit>> createTransaction(Transaction transaction);
  Future<Either<Failure, Unit>> updateTransaction(Transaction transaction);
  Future<Either<Failure, List<Transaction>>> getTransactions();
  Future<Either<Failure, List<Transaction>>> getTransactionsByStaffId(String staffId);
  Future<Either<Failure, List<Transaction>>> getTransactionsByUserId(String userId);
  Future<Either<Failure, List<Transaction>>> getTransactionsByTimeSpan(TimeSpan timeSpan);
  Future<Either<Failure, List<Transaction>>> getFilteredTransactions(FilterTransactionWaste filter);

  Future<Either<Failure, FilterTransactionWaste>> getTransactionWasteFilter();
  Future<Either<Failure, Unit>> saveTransactionWasteFilter(FilterTransactionWaste filter);
}
