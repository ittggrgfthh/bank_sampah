import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_user.freezed.dart';

/// Memfilter pengguna atau user
/// ```dart
/// String? role; null (semua) | warga | staff | admin
/// String? fullName; // digunakan untuk mencari berdasarkan nama user
/// List<String?> villages; // menggunakan whereIn pada query firebase
/// List<String?> rws; // filter lewat aplikasi langsung
/// List<String?> rts; // filter lewat aplikasi langsung
/// ```
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
