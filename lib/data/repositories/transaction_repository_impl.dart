import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/constant/firebase_exception_codes.dart';
import '../../core/failures/failure.dart';
import '../../domain/entities/filter_transaction_waste.dart';
import '../../domain/entities/report.dart';
import '../../domain/entities/transaction_waste.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_data_source.dart';
import '../models/filter_transaction_waste_model.dart';
import '../models/transaction_waste_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _transactionRemoteDataSource;

  TransactionRepositoryImpl(this._transactionRemoteDataSource);

  @override
  Future<Either<Failure, Unit>> createTransaction(TransactionWaste transaction) async {
    try {
      await _transactionRemoteDataSource.createTransaction(TransactionWasteModel.formDomain(transaction));
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.code == FirebaseExceptionCodes.unavailable) {
        return left(const Failure.timeout());
      }
      return left(Failure.unexpected(e.toString()));
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionWaste>>> getTransactions() async {
    try {
      final result = await _transactionRemoteDataSource.getTransactions();
      return right(result.map((transactionWasteModel) => transactionWasteModel.toDomain()).toList());
    } on FirebaseException catch (e) {
      if (e.code == FirebaseExceptionCodes.unavailable) {
        return left(const Failure.timeout());
      }
      return left(Failure.unexpected(e.toString()));
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionWaste>>> getTransactionsByStaffId(String staffId) async {
    try {
      final result = await _transactionRemoteDataSource.getTransactionsByStaffId(staffId);
      return right(result.map((transactionWasteModel) => transactionWasteModel.toDomain()).toList());
    } on FirebaseException catch (e) {
      if (e.code == FirebaseExceptionCodes.unavailable) {
        return left(const Failure.timeout());
      }
      return left(Failure.unexpected(e.toString()));
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionWaste>>> getTransactionsByUserId(String user) async {
    try {
      final result = await _transactionRemoteDataSource.getTransactionsByUserId(user);
      return right(result.map((transactionWasteModel) => transactionWasteModel.toDomain()).toList());
    } on FirebaseException catch (e) {
      if (e.code == FirebaseExceptionCodes.unavailable) {
        return left(const Failure.timeout());
      }
      return left(Failure.unexpected(e.toString()));
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTransaction(TransactionWaste transaction) async {
    try {
      await _transactionRemoteDataSource.updateTransaction(TransactionWasteModel.formDomain(transaction));
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.code == FirebaseExceptionCodes.unavailable) {
        return left(const Failure.timeout());
      }
      return left(Failure.unexpected(e.toString()));
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionWaste>>> getTransactionsByTimeSpan(TimeSpan timeSpan) async {
    try {
      final result = await _transactionRemoteDataSource.getTransactionsByTimeSpan(timeSpan.start, timeSpan.end);
      return right(result.map((transactionWasteModel) => transactionWasteModel.toDomain()).toList());
    } on FirebaseException catch (e) {
      if (e.code == FirebaseExceptionCodes.unavailable) {
        return left(const Failure.timeout());
      }
      return left(Failure.unexpected(e.toString()));
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionWaste>>> getFilteredTransactions(FilterTransactionWaste filter) async {
    try {
      final result =
          await _transactionRemoteDataSource.getFilteredTransactions(FilterTransactionWasteModel.formDomain(filter));
      return right(result.map((transactionWasteModel) => transactionWasteModel.toDomain()).toList());
    } on FirebaseException catch (e) {
      if (e.code == FirebaseExceptionCodes.unavailable) {
        return left(const Failure.timeout());
      }
      return left(Failure.unexpected(e.toString()));
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }
}
