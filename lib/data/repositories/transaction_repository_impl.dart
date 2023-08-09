// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bank_sampah/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/constant/firebase_exception_codes.dart';
import '../../core/failures/failure.dart';
import '../../domain/entities/transaction_waste.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_data_source.dart';
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
      final listTransactionWasteModel = await _transactionRemoteDataSource.getTransactions();
      return right(listTransactionWasteModel.map((transactionWasteModel) => transactionWasteModel.toDomain()).toList());
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
  Future<Either<Failure, List<TransactionWaste>>> getTransactionsByStaff(User staff) async {
    try {
      final listTransactionWasteModel =
          await _transactionRemoteDataSource.getTransactionsByStaff(UserModel.formDomain(staff));
      return right(listTransactionWasteModel.map((transactionWasteModel) => transactionWasteModel.toDomain()).toList());
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
  Future<Either<Failure, List<TransactionWaste>>> getTransactionsByUser(User user) async {
    try {
      final listTransactionWasteModel =
          await _transactionRemoteDataSource.getTransactionsByStaff(UserModel.formDomain(user));
      return right(listTransactionWasteModel.map((transactionWasteModel) => transactionWasteModel.toDomain()).toList());
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
