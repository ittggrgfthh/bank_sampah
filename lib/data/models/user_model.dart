import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/point_balance.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/waste.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  @JsonSerializable(explicitToJson: true)
  const factory UserModel({
    required String id,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    @Default('WARGA') String role,
    required String password,
    @JsonKey(name: 'photo_profile') String? photoProfile,
    String? rt,
    String? rw,
    String? village,
    @JsonKey(name: 'created_at') required int createdAt,
    @JsonKey(name: 'updated_at') required int updatedAt,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  factory UserModel.formDomain(User user) {
    return UserModel(
      id: user.id.toString(),
      phoneNumber: user.phoneNumber,
      role: user.role,
      password: user.password,
      fullName: user.fullName ?? '',
      photoProfile: user.photoUrl,
      rt: user.rt,
      rw: user.rw,
      village: user.village,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  User toDomain() {
    return User(
      id: 0,
      phoneNumber: phoneNumber,
      role: role,
      password: password,
      fullName: fullName,
      photoUrl: photoProfile,
      balance: 0,
      rt: rt!,
      rw: rw!,
      village: village,
      totalInorganicWeight: 0,
      totalOrganicWeight: 0,
      totalWasteWeight: 0,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
