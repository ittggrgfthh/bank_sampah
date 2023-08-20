import 'package:freezed_annotation/freezed_annotation.dart';

import 'point_balance.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String phoneNumber,
    required String role,
    required String password,
    String? fullName,
    String? photoUrl,
    required PointBalance pointBalance,
    required String rt,
    required String rw,
    required int createdAt,
    required int updatedAt,
    int? lastTransactionEpoch,
  }) = _User;

  const User._();
}
