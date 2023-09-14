import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_user.freezed.dart';

@freezed
class FilterUser with _$FilterUser {
  const factory FilterUser({
    String? userId,
    String? fullName,
    String? role,
    List<String>? villages,
    List<String>? rts,
    List<String>? rws,
  }) = _FilterUser;

  const FilterUser._();
}
