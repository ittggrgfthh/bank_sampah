part of 'transaction_history_bloc.dart';

@freezed
class TransactionHistoryEvent with _$TransactionHistoryEvent {
  const factory TransactionHistoryEvent.initialized(String staffId) = _Initialized;
}
