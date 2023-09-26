part of 'edit_waste_price_bloc.dart';

@freezed
class EditWastePriceEvent with _$EditWastePriceEvent {
  const factory EditWastePriceEvent.initialized(User user) = _Initialized;
  const factory EditWastePriceEvent.priceOrganicChanged(String priceOrganic) = _PriceOrganicChanged;
  const factory EditWastePriceEvent.priceInorganicChanged(String priceInorganic) = _PriceInorganicChanged;
  const factory EditWastePriceEvent.submitButtonPressed() = _SubmitButtonPressed;
}
