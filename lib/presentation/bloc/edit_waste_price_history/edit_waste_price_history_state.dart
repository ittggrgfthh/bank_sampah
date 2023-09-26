part of 'edit_waste_price_history_bloc.dart';

@freezed
class EditWastePriceHistoryState with _$EditWastePriceHistoryState {
  const factory EditWastePriceHistoryState.initial() = _Initial;
  const factory EditWastePriceHistoryState.loadInProgress() = _LoadInProgress;
  const factory EditWastePriceHistoryState.loadSuccess(List<WastePrice> editWastePriceHistory) = _LoadSuccess;
  const factory EditWastePriceHistoryState.loadFailure(Failure failure) = _LoadFailure;
}
