import 'package:bank_sampah/domain/entities/waste_price.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_model.dart';

part 'waste_price_model.freezed.dart';
part 'waste_price_model.g.dart';

@freezed
class WastePriceModel with _$WastePriceModel {
  const factory WastePriceModel({
    required String id,
    required int organic,
    required int inorganic,
    @JsonKey(name: 'create_at') required int createAt,
    required UserModel admin,
  }) = _WastePriceModel;

  const WastePriceModel._();

  factory WastePriceModel.fromJson(Map<String, dynamic> json) => _$WastePriceModelFromJson(json);

  factory WastePriceModel.formDomain(WastePrice wastePrice) {
    return WastePriceModel(
      id: wastePrice.id,
      organic: wastePrice.organic,
      inorganic: wastePrice.inorganic,
      createAt: wastePrice.createAt,
      admin: UserModel.formDomain(wastePrice.admin),
    );
  }

  WastePrice toDomain() {
    return WastePrice(
      id: id,
      organic: organic,
      inorganic: inorganic,
      createAt: createAt,
      admin: admin.toDomain(),
    );
  }
}
