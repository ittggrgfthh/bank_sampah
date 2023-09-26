part of 'filter_transaction_waste_bloc.dart';

@freezed
class FilterTransactionWasteEvent with _$FilterTransactionWasteEvent {
  const factory FilterTransactionWasteEvent.loaded() = _Loaded;
  const factory FilterTransactionWasteEvent.apply(FilterTransactionWaste filter) = _Apply;
  const factory FilterTransactionWasteEvent.reset() = _Reset;
}
