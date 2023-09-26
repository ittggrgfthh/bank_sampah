import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/point_balance.dart';
import 'waste_model.dart';

part 'point_balance_model.freezed.dart';
part 'point_balance_model.g.dart';

@freezed
class PointBalanceModel with _$PointBalanceModel {
  @JsonSerializable(explicitToJson: true)
  const factory PointBalanceModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'current_balance') required int currentBalance,
    required WasteModel waste,
  }) = _PointBalanceModel;

  const PointBalanceModel._();

  factory PointBalanceModel.fromJson(Map<String, dynamic> json) => _$PointBalanceModelFromJson(json);

  PointBalance toDomain() {
    return PointBalance(
      userId: userId,
      currentBalance: currentBalance,
      waste: waste.toDomain(),
    );
  }

  static PointBalanceModel formDomain(PointBalance pointBalance) {
    return PointBalanceModel(
      userId: pointBalance.userId,
      currentBalance: pointBalance.currentBalance,
      waste: WasteModel.formDomain(pointBalance.waste),
    );
  }
}
