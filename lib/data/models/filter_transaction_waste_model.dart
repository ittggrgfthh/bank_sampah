import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/filter_transaction_waste.dart';

part 'filter_transaction_waste_model.freezed.dart';
part 'filter_transaction_waste_model.g.dart';

@freezed
class FilterTransactionWasteModel with _$FilterTransactionWasteModel {
  @JsonSerializable(explicitToJson: true)
  const factory FilterTransactionWasteModel({
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'staff_id') String? staffId,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'start_epoch') int? startEpoch,
    @JsonKey(name: 'end_epoch') int? endEpoch,
    List<String>? villages,
    List<String>? rts,
    List<String>? rws,
    @JsonKey(name: 'is_store_waste') @Default(false) bool isStoreWaste,
    @JsonKey(name: 'is_withdraw_balance') @Default(false) bool isWithdrawBalance,
  }) = _FilterTransactionWaste;

  const FilterTransactionWasteModel._();

  factory FilterTransactionWasteModel.fromJson(Map<String, dynamic> json) =>
      _$FilterTransactionWasteModelFromJson(json);

  FilterTransactionWaste toDomain() {
    return FilterTransactionWaste(
      userId: userId,
      staffId: staffId,
      fullName: fullName,
      startEpoch: startEpoch,
      endEpoch: endEpoch,
      villages: villages,
      rts: rts,
      rws: rws,
      isStoreWaste: isStoreWaste,
      isWithdrawBalance: isWithdrawBalance,
    );
  }

  static FilterTransactionWasteModel formDomain(FilterTransactionWaste filterTransactionWaste) {
    return FilterTransactionWasteModel(
      userId: filterTransactionWaste.userId,
      staffId: filterTransactionWaste.staffId,
      fullName: filterTransactionWaste.fullName,
      startEpoch: filterTransactionWaste.startEpoch,
      endEpoch: filterTransactionWaste.endEpoch,
      villages: filterTransactionWaste.villages,
      rts: filterTransactionWaste.rts,
      rws: filterTransactionWaste.rws,
      isStoreWaste: filterTransactionWaste.isStoreWaste,
      isWithdrawBalance: filterTransactionWaste.isWithdrawBalance,
    );
  }
}
