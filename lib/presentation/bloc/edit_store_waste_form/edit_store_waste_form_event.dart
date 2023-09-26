part of 'edit_store_waste_form_bloc.dart';

@freezed
class EditStoreWasteFormEvent with _$EditStoreWasteFormEvent {
  const factory EditStoreWasteFormEvent.initialized(TransactionWaste transactionWaste) = _Initialized;
  const factory EditStoreWasteFormEvent.organicWeightChanged(String organicWeight) = _OrganicWeightChanged;
  const factory EditStoreWasteFormEvent.inorganicWeightChanged(String inorganicWeight) = _InorganicWeightChanged;
  const factory EditStoreWasteFormEvent.submitButtonPressed() = _SubmitButtonPressed;
}
