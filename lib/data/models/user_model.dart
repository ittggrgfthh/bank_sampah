import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(includeFromJson: false, includeToJson: false) String? id,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    @Default('warga') String role,
    required String password,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'photo_url') String? photoUrl,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      UserModel.fromJson(doc.data()!).copyWith(id: doc.id);

  factory UserModel.formDomain(User user) {
    return UserModel(
      id: user.id,
      phoneNumber: user.phoneNumber,
      role: user.role,
      password: user.password,
      fullName: user.fullName,
      photoUrl: user.photoUrl,
    );
  }

  User toDomain() {
    return User(
      id: id!,
      phoneNumber: phoneNumber,
      role: role,
      password: password,
      fullName: fullName,
      photoUrl: photoUrl,
    );
  }
}
