import 'package:freezed_annotation/freezed_annotation.dart';

part 'waste.freezed.dart';

@freezed
class Waste with _$Waste {
  const factory Waste({
    required int organic,
    required int inorganic,
  }) = _Waste;

  const Waste._();
}
