import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/filter_transaction_waste_model.dart';
import '../models/filter_user_model.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<void> saveLoggedInUser(UserModel user);
  Future<UserModel?> getLoggedInUser();
  Future<void> clearLoggedInUser();
  Future<void> saveUserFilter(FilterUserModel filterUserModel);
  Future<FilterUserModel> getUserFilter();
  Future<void> saveTransactionFilter(FilterTransactionWasteModel filterTransactionWasteModel);
  Future<FilterUserModel> resetDefaultUserFilter();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  static const String _loggedInUserKey = 'logged_in_user';
  static const String _userFilterDefaultKey = 'user_filter_default';
  static const String _userFilterKey = 'user_filter';
  static const String _transactionFilterDefaultKey = 'transaction_filter_default';
  static const String _transactionFilterKey = 'transaction_filter';

  @override
  Future<void> saveLoggedInUser(UserModel user) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    FilterUserModel filterUserModel = FilterUserModel(villages: [user.village ?? 'Banyubiru']);

    final dateTime = DateTime.now();
    FilterTransactionWasteModel filterTransactionWasteModel = FilterTransactionWasteModel(
      startEpoch: dateTime.copyWith(month: dateTime.month - 1).millisecondsSinceEpoch,
      endEpoch: dateTime.millisecondsSinceEpoch,
    );
    switch (user.role) {
      case 'staff':
        filterUserModel = filterUserModel.copyWith(role: 'warga');
        filterTransactionWasteModel = filterTransactionWasteModel.copyWith(staffId: user.id);
        break;
      case 'warga':
        filterTransactionWasteModel = filterTransactionWasteModel.copyWith(userId: user.id);
      default:
    }

    final userFilterJson = filterUserModel.toJson();
    await sharedPreferences.setString(_userFilterDefaultKey, jsonEncode(userFilterJson));

    await saveUserFilter(filterUserModel);
    await saveTransactionFilter(filterTransactionWasteModel);
    final userJson = user.toJson();
    await sharedPreferences.setString(_loggedInUserKey, jsonEncode(userJson));
  }

  @override
  Future<UserModel?> getLoggedInUser() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userJson = sharedPreferences.getString(_loggedInUserKey);
    if (userJson != null) {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  @override
  Future<void> clearLoggedInUser() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_userFilterKey);
    await sharedPreferences.remove(_loggedInUserKey);
    await sharedPreferences.remove(_transactionFilterDefaultKey);
    await sharedPreferences.remove(_transactionFilterKey);
  }

  @override
  Future<void> saveUserFilter(FilterUserModel filterUserModel) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userFilterJson = filterUserModel.toJson();
    await sharedPreferences.setString(_userFilterKey, jsonEncode(userFilterJson));
  }

  @override
  Future<FilterUserModel> getUserFilter() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userFilterJson = sharedPreferences.getString(_userFilterKey);
    if (userFilterJson != null) {
      final userFilterMap = jsonDecode(userFilterJson) as Map<String, dynamic>;
      return FilterUserModel.fromJson(userFilterMap);
    } else {
      return resetDefaultUserFilter();
    }
  }

  @override
  Future<void> saveTransactionFilter(FilterTransactionWasteModel filterTransactionWasteModel) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final transactionFilterJson = filterTransactionWasteModel.toJson();
    await sharedPreferences.setString(_transactionFilterDefaultKey, jsonEncode(transactionFilterJson));
    await sharedPreferences.setString(_transactionFilterKey, jsonEncode(transactionFilterJson));
  }

  @override
  Future<FilterUserModel> resetDefaultUserFilter() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userFilterDefaultString = sharedPreferences.getString(_userFilterDefaultKey);

    if (userFilterDefaultString != null) {
      sharedPreferences.setString(_userFilterKey, userFilterDefaultString);
      return FilterUserModel.fromJson(jsonDecode(userFilterDefaultString));
    } else {
      const filterUserModelDefault = FilterUserModel(villages: ['Banyubiru'], role: 'warga');
      sharedPreferences.setString(_userFilterDefaultKey, jsonEncode(filterUserModelDefault.toJson()));
      return filterUserModelDefault;
    }
  }
}
