import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/utils/exception.dart';
import '../../core/utils/firebase_extensions.dart';
import '../../core/utils/app_helper.dart';
import '../models/transaction_waste_model.dart';
import '../models/user_model.dart';

abstract class TransactionRemoteDataSource {
  /// Membuat transaksi saat "simpan limbah" dan "tarik saldo"
  Future<void> createTransaction(TransactionWasteModel transaction);

  /// Mendapatkan semua transaksi
  Future<List<TransactionWasteModel>> getTransactions();

  /// Mendapatkan semua transaksi yang dilakukan oleh staff
  Future<List<TransactionWasteModel>> getTransactionsByStaff(UserModel staff);

  /// Mendapatkan semua transaksi yang dilakukan oleh user
  Future<List<TransactionWasteModel>> getTransactionsByUser(UserModel user);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final FirebaseFirestore _firestore;

  const TransactionRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> createTransaction(TransactionWasteModel transaction) async {
    final batch = _firestore.batch();
    final userDocRef = _firestore.userDocRef(transaction.user.id);
    final pointBalanceDocRef = _firestore.pointBalanceDocRef(transaction.user.id);

    final newTransaction = transaction.copyWith(id: 'transaction_${AppHelper.v4UUIDWithoutDashes()}');
    final transactionDocRef = _firestore.transactionDocRef(newTransaction.id);

    try {
      batch.set(userDocRef, newTransaction.user.toJson());
      batch.set(pointBalanceDocRef, newTransaction.user.pointBalance.toJson());
      batch.set(transactionDocRef, newTransaction.toJson());
      await batch.commit();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<TransactionWasteModel>> getTransactions() async {
    final transactionRef = _firestore.transactionColRef.withConverter<TransactionWasteModel>(
      fromFirestore: (snapshot, options) => TransactionWasteModel.fromJson(snapshot.data()!),
      toFirestore: (value, options) => value.toJson(),
    );
    try {
      final querySnapshot = await transactionRef.orderBy('updated_at', descending: true).get();
      return querySnapshot.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<TransactionWasteModel>> getTransactionsByStaff(UserModel staff) async {
    final transactionRef = _firestore.transactionColRef.withConverter<TransactionWasteModel>(
      fromFirestore: (snapshot, options) => TransactionWasteModel.fromJson(snapshot.data()!),
      toFirestore: (value, options) => value.toJson(),
    );
    try {
      final querySnapshot =
          await transactionRef.where('staff.id', isEqualTo: staff.id).orderBy('updated_at', descending: true).get();
      return querySnapshot.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<TransactionWasteModel>> getTransactionsByUser(UserModel user) async {
    final transactionRef = _firestore.transactionColRef.withConverter<TransactionWasteModel>(
      fromFirestore: (snapshot, options) => TransactionWasteModel.fromJson(snapshot.data()!),
      toFirestore: (value, options) => value.toJson(),
    );
    try {
      final querySnapshot =
          await transactionRef.where('user.id', isEqualTo: user.id).orderBy('updated_at', descending: true).get();
      return querySnapshot.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw ServerException();
    }
  }
}
