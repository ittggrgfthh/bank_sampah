import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<void> saveLoggedInUser(UserModel user);
  Future<UserModel?> getLoggedInUser();
  Future<void> clearLoggedInUser();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  static const String _loggedInUserKey = 'logged_in_user';

  @override
  Future<void> saveLoggedInUser(UserModel user) async {
    final sharedPreferences = await SharedPreferences.getInstance();
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
    await sharedPreferences.remove(_loggedInUserKey);
  }
}
