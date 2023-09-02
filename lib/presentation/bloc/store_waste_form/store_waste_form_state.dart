part of 'store_waste_form_bloc.dart';

@freezed
class StoreWasteFormState with _$StoreWasteFormState {
  const factory StoreWasteFormState({
    required bool isLoading,
    required Option<Failure> failure,
    required Option<User> user,
    required Option<TransactionWaste> transaction,
    required String organicWeight,
    required String inorganicWeight,
    required String priceOrganic,
    required String priceInorganic,
    required String earnedBalance,
    required bool isChange,
    required Option<Either<Failure, Unit>> failureOrSuccessOption,
  }) = _StoreWasteFormState;

  factory StoreWasteFormState.initial() => StoreWasteFormState(
        isLoading: false,
        failure: none(),
        user: none(),
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
