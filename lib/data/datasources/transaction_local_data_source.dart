import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/filter_transaction_waste_model.dart';

abstract class TransactionLocalDataSource {
  Future<void> saveTransactionFilter(FilterTransactionWasteModel filterTransactionWasteModel);
  Future<FilterTransactionWasteModel> getTransactionFilter();
  Future<FilterTransactionWasteModel> resetDefaultTransactionFilter();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  static const String _transactionFilterKey = 'transaction_filter';
  static const String _transactionFilterDefaultKey = 'transaction_filter_default';

  @override
  Future<void> saveTransactionFilter(FilterTransactionWasteModel filterTransactionWasteModel) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final transactionFilterJson = filterTransactionWasteModel.toJson();
    await sharedPreferences.setString(_transactionFilterKey, jsonEncode(transactionFilterJson));
  }

  @override
  Future<FilterTransactionWasteModel> getTransactionFilter() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final transactionFilterJson = sharedPreferences.getString(_transactionFilterKey);
    if (transactionFilterJson != null) {
      final transactionFilterMap = jsonDecode(transactionFilterJson) as Map<String, dynamic>;
      return FilterTransactionWasteModel.fromJson(transactionFilterMap);
    } else {
      return resetDefaultTransactionFilter();
    }
  }

  @override
  Future<FilterTransactionWasteModel> resetDefaultTransactionFilter() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final transactionFilterDefaultString = sharedPreferences.getString(_transactionFilterDefaultKey);
    if (transactionFilterDefaultString != null) {
      sharedPreferences.setString(_transactionFilterKey, transactionFilterDefaultString);
      return FilterTransactionWasteModel.fromJson(jsonDecode(transactionFilterDefaultString));
    } else {
      final dateTime = DateTime.now();
      Map<String, dynamic> json = {
        'user_id': null,
        'staff_id': null,
        'full_name': null,
        'start_epoch': dateTime.copyWith(month: dateTime.month - 1).millisecondsSinceEpoch,
        'end_epoch': dateTime.millisecondsSinceEpoch,
        'villages': [],
        'rts': [],
        'rws': [],
        'is_store_waste': false,
        'is_withdraw_balance': false,
      };

      sharedPreferences.setString(_transactionFilterDefaultKey, jsonEncode(json));
      return FilterTransactionWasteModel.fromJson(json);
    }
  }
}
