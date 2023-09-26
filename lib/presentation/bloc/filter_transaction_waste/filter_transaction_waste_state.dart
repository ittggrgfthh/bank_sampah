part of 'filter_transaction_waste_bloc.dart';

@freezed
class FilterTransactionWasteState with _$FilterTransactionWasteState {
  const factory FilterTransactionWasteState.initial() = _Initial;
  const factory FilterTransactionWasteState.loadInProgress() = _LoadInProgress;
  const factory FilterTransactionWasteState.loadSuccess(FilterTransactionWaste filter) = _LoadSuccess;
  const factory FilterTransactionWasteState.loadFailure(String message) = _LoadFailure;
}
