import 'package:freezed_annotation/freezed_annotation.dart';

import 'point_balance.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String phoneNumber,
    required String role,
    required String password,
    String? fullName,
    required String rt,
    required String rw,
    String? photoUrl,
    required int balance,
    required int totalOrganicWeight,
    required int totalInorganicWeight,
    required int totalWasteWeight,
    required int createdAt,
    required int updatedAt,
    String? village,
  }) = _User;

  const User._();
}
