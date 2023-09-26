import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_transaction_waste.freezed.dart';

@freezed
class FilterTransactionWaste with _$FilterTransactionWaste {
  const factory FilterTransactionWaste({
    String? userId,
    String? staffId,
    String? fullName, // for search
    int? startEpoch,
    int? endEpoch,
    List<String>? villages,
    List<String>? rts,
    List<String>? rws,
    @Default(false) bool isStoreWaste,
    @Default(false) bool isWithdrawBalance,
  }) = _FilterTransactionWaste;

  const FilterTransactionWaste._();
}
