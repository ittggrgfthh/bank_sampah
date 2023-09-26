part of 'warga_home_bloc.dart';

@freezed
class WargaHomeState with _$WargaHomeState {
  const factory WargaHomeState({
    required bool isLoading,
    required Option<Failure> failure,
    required Option<List<TransactionWaste>> transactionwaste,
    required String totalBalance,
    required String totalWasteStored, // totalOrganic + totalInorganic
    required String totalOrganic,
    required String totalInorganic,
  }) = _WargaHomeState;

  factory WargaHomeState.initial() => WargaHomeState(
        isLoading: false,
        failure: none(),
        transactionwaste: none(),
        totalBalance: '0',
        totalWasteStored: '0',
        totalOrganic: '0',
        totalInorganic: '0',
      );
}
