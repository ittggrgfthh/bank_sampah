part of 'store_waste_form_bloc.dart';

@freezed
class StoreWasteFormEvent with _$StoreWasteFormEvent {
  const factory StoreWasteFormEvent.initialized(String userId, User staff) = _Initialized;
  const factory StoreWasteFormEvent.organicWeightChanged(String organicWeight) = _OrganicWeightChanged;
  const factory StoreWasteFormEvent.inorganicWeightChanged(String inorganicWeight) = _InorganicWeightChanged;
  const factory StoreWasteFormEvent.submitButtonPressed() = _SubmitButtonPressed;
}
