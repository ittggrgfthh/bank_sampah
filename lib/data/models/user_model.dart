import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';
import 'point_balance_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  @JsonSerializable(explicitToJson: true)
  const factory UserModel({
    required String id,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    @Default('warga') String role,
    required String password,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'point_balance') required PointBalanceModel pointBalance,
    @JsonKey(name: 'created_at') required int createdAt,
    @JsonKey(name: 'updated_at') required int updatedAt,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      UserModel.fromJson(doc.data()!).copyWith(id: doc.id);

  factory UserModel.fromFirestoreQuery(Object object) => UserModel.fromJson(object as Map<String, dynamic>);

  factory UserModel.formDomain(User user) {
    return UserModel(
      id: user.id,
      phoneNumber: user.phoneNumber,
      role: user.role,
      password: user.password,
      fullName: user.fullName,
      photoUrl: user.photoUrl,
      pointBalance: PointBalanceModel.formDomain(user.pointBalance),
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  User toDomain() {
    return User(
      id: id,
      phoneNumber: phoneNumber,
      role: role,
      password: password,
      fullName: fullName,
      photoUrl: photoUrl,
      pointBalance: pointBalance.toDomain(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
