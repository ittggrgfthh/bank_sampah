import 'package:bank_sampah/domain/entities/waste.dart';
import 'package:bank_sampah/domain/entities/waste_price.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'transaction.freezed.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    required User warga,
    required User admin,
    required int totalPrice,
    required int totalWeight,
    required int totalOrganicWeight,
    required int totalInorganicWeight,
    required int totalOrganicPrice,
    required int totalInorganicPrice,
    required String imageUrl,
    required bool isVerified,
    required int createdAt,
    required int updatedAt,
  }) = _Transaction;

  const Transaction._();
}

@freezed
class StoreWaste with _$StoreWaste {
  const factory StoreWaste({
    required int earnedBalance,
    required Waste waste, // kg
    required Waste wasteBalance, // Rp
    required WastePrice wastePrice,
  }) = _StoreWaste;

  const StoreWaste._();
}

@freezed
class WithdrawnBalance with _$WithdrawnBalance {
  const factory WithdrawnBalance({
    required int balance, // saldo sebelumnya
    required int withdrawn, // jumlah yang ditarik
    required int currentBalance, // saldo sekarang dari pengurangan saldo sebelumnya
  }) = _WithdrawnBalance;

  const WithdrawnBalance._();
}

@freezed
class HistoryStoreWaste with _$HistoryStoreWaste {
  const factory HistoryStoreWaste({
    required StoreWaste storeWaste,
    required int updatedAt,
  }) = _HistoryUpdate;

  const HistoryStoreWaste._();
}
