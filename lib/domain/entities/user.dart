import 'package:freezed_annotation/freezed_annotation.dart';

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
    required int createdAt,
    required int updatedAt,
  }) = _User;

  const User._();
}
