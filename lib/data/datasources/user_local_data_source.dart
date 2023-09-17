import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/filter_user_model.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<void> saveLoggedInUser(UserModel user);
  Future<UserModel?> getLoggedInUser();
  Future<void> clearLoggedInUser();
  Future<void> saveUserFilter(FilterUserModel filterUserModel);
  Future<FilterUserModel?> getUserFilter();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  static const String _loggedInUserKey = 'logged_in_user';
  static const String _userFilterKey = 'user_filter';

  @override
  Future<void> saveLoggedInUser(UserModel user) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    FilterUserModel filterUserModel = FilterUserModel(villages: [user.village ?? 'Banyubiru']);
    print(user);
    switch (user.role) {
      case 'staff':
        filterUserModel = filterUserModel.copyWith(role: 'warga');
        break;
      default:
    }
    print(filterUserModel);
    await saveUserFilter(filterUserModel);
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
  }

  @override
  Future<void> saveUserFilter(FilterUserModel filterUserModel) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userFilterJson = filterUserModel.toJson();
    await sharedPreferences.setString(_userFilterKey, jsonEncode(userFilterJson));
  }

  @override
  Future<FilterUserModel?> getUserFilter() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userFilterJson = sharedPreferences.getString(_userFilterKey);
    print(userFilterJson);
    if (userFilterJson != null) {
      final userFilterMap = jsonDecode(userFilterJson) as Map<String, dynamic>;
      return FilterUserModel.fromJson(userFilterMap);
    }
    return null;
  }
}
