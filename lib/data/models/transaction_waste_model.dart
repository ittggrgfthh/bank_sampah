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
    @JsonKey(name: 'withdrawn_balance') required WithdrawnBalanceModel withdrawnBalance,
    required WasteModel waste,
    @JsonKey(name: 'waste_price') required WastePriceModel wastePrice,
    required List<HistoryWasteModel> historyUpdate,
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
      withdrawnBalance: withdrawnBalance.toDomain(),
      waste: waste.toDomain(),
      wastePrice: wastePrice.toDomain(),
      historyUpdate: historyUpdate.map((history) => history.toDomain()).toList(),
    );
  }

  static TransactionWasteModel formDomain(TransactionWaste transaction) {
    return TransactionWasteModel(
      id: transaction.id,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
      user: UserModel.formDomain(transaction.user),
      staff: UserModel.formDomain(transaction.staff),
      withdrawnBalance: WithdrawnBalanceModel.formDomain(transaction.withdrawnBalance),
      waste: WasteModel.formDomain(transaction.waste),
      wastePrice: WastePriceModel.formDomain(transaction.wastePrice),
      historyUpdate: transaction.historyUpdate.map((history) => HistoryWasteModel.formDomain(history)).toList(),
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
class HistoryWasteModel with _$HistoryWasteModel {
  @JsonSerializable(explicitToJson: true)
  const factory HistoryWasteModel({
    required WasteModel waste,
    @JsonKey(name: 'updated_at') required int updatedAt,
  }) = _HistoryWasteModel;

  const HistoryWasteModel._();

  factory HistoryWasteModel.fromJson(Map<String, dynamic> json) => _$HistoryWasteModelFromJson(json);

  HistoryWaste toDomain() {
    return HistoryWaste(
      waste: waste.toDomain(),
      updatedAt: updatedAt,
    );
  }

  static HistoryWasteModel formDomain(HistoryWaste history) {
    return HistoryWasteModel(
      waste: WasteModel.formDomain(history.waste),
      updatedAt: history.updatedAt,
    );
  }
}
