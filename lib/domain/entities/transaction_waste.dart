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
    required WithdrawnBalance withdrawnBalance,
    required Waste waste,
    required WastePrice wastePrice,
    required List<HistoryWaste> historyUpdate,
  }) = _TransactionWaste;

  const TransactionWaste._();
}

@freezed
class WithdrawnBalance with _$WithdrawnBalance {
  const factory WithdrawnBalance({
    required int balance,
    required int withdrawn,
    required int currentBalance,
  }) = _WithdrawnBalance;

  const WithdrawnBalance._();
}

@freezed
class HistoryWaste with _$HistoryWaste {
  const factory HistoryWaste({
    required Waste waste,
    required int updatedAt,
  }) = _HistoryUpdate;

  const HistoryWaste._();
}
