import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/transaction_waste.dart';
import 'user_model.dart';
import 'waste_model.dart';
import 'waste_price_model.dart';

part 'transaction_waste_model.freezed.dart';
part 'transaction_waste_model.g.dart';

@freezed
class TransactionWasteModel with _$TransactionWasteModel {
  @JsonSerializable(explicitToJson: true)
  const factory TransactionWasteModel({
    required String id,
    @JsonKey(name: 'created_at') required int createdAt,
    @JsonKey(name: 'updated_at') required int updatedAt,
    required UserModel user,
    required UserModel staff,
    @JsonKey(name: 'store_waste') StoreWasteModel? storeWaste,
    @JsonKey(name: 'withdrawn_balance') WithdrawnBalanceModel? withdrawnBalance,
    @JsonKey(name: 'history_store_waste') required List<HistoryStoreWasteModel> historyStoreWaste,
  }) = _TransactionWasteModel;

  const TransactionWasteModel._();

  factory TransactionWasteModel.fromJson(Map<String, dynamic> json) => _$TransactionWasteModelFromJson(json);

  TransactionWaste toDomain() {
    return TransactionWaste(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      user: user.toDomain(),
      staff: staff.toDomain(),
      withdrawnBalance: withdrawnBalance?.toDomain(),
      storeWaste: storeWaste?.toDomain(),
      historyStoreWaste: historyStoreWaste.map((history) => history.toDomain()).toList(),
    );
  }

  static TransactionWasteModel formDomain(TransactionWaste transaction) {
    return TransactionWasteModel(
      id: transaction.id,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
      user: UserModel.formDomain(transaction.user),
      staff: UserModel.formDomain(transaction.staff),
      withdrawnBalance:
          transaction.withdrawnBalance == null ? null : WithdrawnBalanceModel.formDomain(transaction.withdrawnBalance!),
      storeWaste: transaction.storeWaste == null ? null : StoreWasteModel.formDomain(transaction.storeWaste!),
      historyStoreWaste:
          transaction.historyStoreWaste.map((history) => HistoryStoreWasteModel.formDomain(history)).toList(),
    );
  }
}

@freezed
class StoreWasteModel with _$StoreWasteModel {
  @JsonSerializable(explicitToJson: true)
  const factory StoreWasteModel({
    @JsonKey(name: 'earned_balance') required int earnedBalance,
    required WasteModel waste,
    @JsonKey(name: 'waste_balance') required WasteModel wasteBalance,
    @JsonKey(name: 'waste_price') required WastePriceModel wastePrice,
  }) = _StoreWasteModel;

  const StoreWasteModel._();

  factory StoreWasteModel.fromJson(Map<String, dynamic> json) => _$StoreWasteModelFromJson(json);

  StoreWaste toDomain() {
    return StoreWaste(
      earnedBalance: earnedBalance,
      waste: waste.toDomain(),
      wasteBalance: wasteBalance.toDomain(),
      wastePrice: wastePrice.toDomain(),
    );
  }

  static StoreWasteModel formDomain(StoreWaste storeWaste) {
    return StoreWasteModel(
      earnedBalance: storeWaste.earnedBalance,
      waste: WasteModel.formDomain(storeWaste.waste),
      wasteBalance: WasteModel.formDomain(storeWaste.wasteBalance),
      wastePrice: WastePriceModel.formDomain(storeWaste.wastePrice),
    );
  }
}

@freezed
class WithdrawnBalanceModel with _$WithdrawnBalanceModel {
  @JsonSerializable(explicitToJson: true)
  const factory WithdrawnBalanceModel({
    required int balance,
    required int withdrawn,
    @JsonKey(name: 'current_balance') required int currentBalance,
  }) = _WithdrawnBalanceModel;

  const WithdrawnBalanceModel._();

  factory WithdrawnBalanceModel.fromJson(Map<String, dynamic> json) => _$WithdrawnBalanceModelFromJson(json);

  WithdrawnBalance toDomain() {
    return WithdrawnBalance(
      balance: balance,
      withdrawn: withdrawn,
      currentBalance: currentBalance,
    );
  }

  static WithdrawnBalanceModel formDomain(WithdrawnBalance withdrawnBalance) {
    return WithdrawnBalanceModel(
      balance: withdrawnBalance.balance,
      withdrawn: withdrawnBalance.withdrawn,
      currentBalance: withdrawnBalance.currentBalance,
    );
  }
}

@freezed
class HistoryStoreWasteModel with _$HistoryStoreWasteModel {
  @JsonSerializable(explicitToJson: true)
  const factory HistoryStoreWasteModel({
    @JsonKey(name: 'store_waste') required StoreWasteModel storeWaste,
    @JsonKey(name: 'updated_at') required int updatedAt,
  }) = _HistoryWasteModel;

  const HistoryStoreWasteModel._();

  factory HistoryStoreWasteModel.fromJson(Map<String, dynamic> json) => _$HistoryStoreWasteModelFromJson(json);

  HistoryStoreWaste toDomain() {
    return HistoryStoreWaste(
      storeWaste: storeWaste.toDomain(),
      updatedAt: updatedAt,
    );
  }

  static HistoryStoreWasteModel formDomain(HistoryStoreWaste history) {
    return HistoryStoreWasteModel(
      storeWaste: StoreWasteModel.formDomain(history.storeWaste),
      updatedAt: history.updatedAt,
    );
  }
}
