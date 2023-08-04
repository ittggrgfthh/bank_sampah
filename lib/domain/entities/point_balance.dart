import 'package:freezed_annotation/freezed_annotation.dart';

import 'waste.dart';

part 'point_balance.freezed.dart';

@freezed
class PointBalance with _$PointBalance {
  const factory PointBalance({
    required String userId,
    required int currentBalance,
    required Waste waste,
  }) = _PointBalance;

  const PointBalance._();
}
