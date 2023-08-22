import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';
import 'waste.dart';
import 'waste_price.dart';

part 'transaction_waste.freezed.dart';

@freezed
class TransactionWaste with _$TransactionWaste {
  const factory TransactionWaste({
    required String id,
    required int createdAt,
    required int updatedAt,
    required User user,
    required User staff,
    StoreWaste? storeWaste, // menyimpan limbah atau input sampah
    WithdrawnBalance? withdrawnBalance, // menarik saldo
    required List<HistoryWaste> historyUpdate,
  }) = _TransactionWaste;

  const TransactionWaste._();
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
class HistoryWaste with _$HistoryWaste {
  const factory HistoryWaste({
    required StoreWaste storeWaste,
    required int updatedAt,
  }) = _HistoryUpdate;

  const HistoryWaste._();
}
