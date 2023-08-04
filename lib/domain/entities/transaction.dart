import 'package:bank_sampah/domain/entities/waste_price.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';
import 'waste.dart';

part 'transaction.freezed.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required int createAt,
    required int updateAt,
    required User user,
    required User staff,
    required WithdrawnBalance withdrawnBalance,
    required Waste waste,
    required WastePrice priceWaste,
    required List<HistoryWaste> historyUpdate,
  }) = _Transaction;

  const Transaction._();
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
    required int updateAt,
  }) = _HistoryUpdate;

  const HistoryWaste._();
}
