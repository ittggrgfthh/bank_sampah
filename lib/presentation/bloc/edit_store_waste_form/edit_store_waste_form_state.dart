part of 'edit_store_waste_form_bloc.dart';

@freezed
class EditStoreWasteFormState with _$EditStoreWasteFormState {
  const factory EditStoreWasteFormState({
    required bool isLoading,
    required Option<Failure> failure,
    required Option<TransactionWaste> transaction,
    required String organicWeight,
    required String inorganicWeight,
    required String priceOrganic,
    required String priceInorganic,
    required String earnedBalance,
    required bool isChange,
    required Option<Either<Failure, Unit>> failureOrSuccessOption,
  }) = _EditStoreWasteFormState;

  factory EditStoreWasteFormState.initial() => EditStoreWasteFormState(
        isLoading: false,
        failure: none(),
        transaction: none(),
        organicWeight: '0',
        inorganicWeight: '0',
        priceOrganic: '...',
        priceInorganic: '...',
        earnedBalance: '0',
        isChange: false,
        failureOrSuccessOption: none(),
      );
}
