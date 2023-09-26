part of 'edit_waste_price_bloc.dart';

@freezed
class EditWastePriceState with _$EditWastePriceState {
  const factory EditWastePriceState({
    required bool isLoading,
    required Option<Failure> failure,
    required Option<User> user,
    required Option<WastePrice> wastePrice,
    required String priceOrganic,
    required String priceInorganic,
    required bool isChange,
    required String currentTimeAgo,
    required String currentAdminFullName,
  }) = _EditWastePriceState;

  factory EditWastePriceState.initial() => EditWastePriceState(
        isLoading: false,
        failure: none(),
        user: none(),
        wastePrice: none(),
        priceOrganic: '',
        priceInorganic: '',
        isChange: false,
        currentTimeAgo: '...',
        currentAdminFullName: '...',
      );
}
