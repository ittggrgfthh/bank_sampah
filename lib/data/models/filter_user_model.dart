import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/filter_user.dart';

part 'filter_user_model.freezed.dart';
part 'filter_user_model.g.dart';

@freezed
class FilterUserModel with _$FilterUserModel {
  @JsonSerializable(explicitToJson: true)
  const factory FilterUserModel({
    String? userId,
    @JsonKey(name: 'full_name') String? fullName,
    String? role,
    List<String>? villages,
    List<String>? rts,
    List<String>? rws,
  }) = _FilterUserModel;

  const FilterUserModel._();

  factory FilterUserModel.fromJson(Map<String, dynamic> json) => _$FilterUserModelFromJson(json);

  FilterUser toDomain() {
    return FilterUser(
      userId: userId,
      fullName: fullName,
      role: role,
      villages: villages,
      rts: rts,
      rws: rws,
    );
  }

  static FilterUserModel formDomain(FilterUser filterUser) {
    return FilterUserModel(
      userId: filterUser.userId,
      fullName: filterUser.fullName,
      role: filterUser.role,
      villages: filterUser.villages,
      rts: filterUser.rts,
    );
  }
}
