import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'waste_price.freezed.dart';

@freezed
class WastePrice with _$WastePrice {
  const factory WastePrice({
    required String id,
    required int organic,
    required int inorganic,
    required int createdAt,
    required User admin,
  }) = _WastePrice;

  const WastePrice._();
}
