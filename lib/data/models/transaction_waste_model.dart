import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/transaction.dart';
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

  Transaction toDomain() {
    return Transaction(
      id: 0,
      createdAt: createdAt,
      updatedAt: updatedAt,
      warga: user.toDomain(),
      admin: staff.toDomain(),
      imageUrl: '',
      totalInorganicPrice: 0,
      totalInorganicWeight: 0,
      totalOrganicPrice: 0,
      totalOrganicWeight: 0,
      totalPrice: 0,
      totalWeight: 0,
      isVerified: false,
    );
  }

  static TransactionWasteModel formDomain(Transaction transaction) {
    return TransactionWasteModel(
      id: transaction.id.toString(),
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
      user: UserModel.formDomain(transaction.warga),
      staff: UserModel.formDomain(transaction.admin),
      withdrawnBalance: const WithdrawnBalanceModel(balance: 0, withdrawn: 0, currentBalance: 0),
      storeWaste: const StoreWasteModel(
        earnedBalance: 0,
        waste: WasteModel(organic: 0, inorganic: 0),
        wasteBalance: WasteModel(organic: 0, inorganic: 0),
        wastePrice: WastePriceModel(
          id: '1',
          organic: 0,
          inorganic: 0,
          createdAt: 0,
          admin: UserModel(
            id: '1',
            fullName: 'Asep Garong',
            password: 'password',
            phoneNumber: '28138217381238',
            photoProfile: '',
            role: 'admin',
            rt: '1',
            rw: '2',
            village: 'Banyubiru',
            createdAt: 0,
            updatedAt: 0,
          ),
        ),
      ),
      historyStoreWaste: [],
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
