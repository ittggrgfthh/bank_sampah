import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'transaction_waste.freezed.dart';

@freezed
class TransactionWaste with _$TransactionWaste {
  const factory TransactionWaste({
    required int wasteId,
    required int transactionId,
    required int price,
    required int weight,
    required int createdAt,
    required int updatedAt,
  }) = _TransactionWaste;

  const TransactionWaste._();
}
