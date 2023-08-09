part of 'transaction_history_bloc.dart';

@freezed
class TransactionHistoryState with _$TransactionHistoryState {
  const factory TransactionHistoryState.initial() = _Initial;
  const factory TransactionHistoryState.loadInProgress() = _LoadInProgress;
  const factory TransactionHistoryState.loadSuccess(List<TransactionWaste> transactionWaste) = _LoadSuccess;
  const factory TransactionHistoryState.loadFailure(Failure failure) = _LoadFailure;
}
