import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/waste.dart';

part 'waste_model.freezed.dart';
part 'waste_model.g.dart';

@freezed
class WasteModel with _$WasteModel {
  @JsonSerializable(explicitToJson: true)
  const factory WasteModel({
    required int organic,
    required int inorganic,
  }) = _WasteModel;

  const WasteModel._();

  factory WasteModel.fromJson(Map<String, dynamic> json) => _$WasteModelFromJson(json);

  Waste toDomain() {
    return Waste(
      organic: organic,
      inorganic: inorganic,
    );
  }

  static WasteModel formDomain(Waste waste) {
    return WasteModel(
      organic: waste.organic,
      inorganic: waste.inorganic,
    );
  }
}
