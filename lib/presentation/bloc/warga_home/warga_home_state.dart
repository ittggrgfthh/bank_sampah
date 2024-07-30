part of 'warga_home_bloc.dart';

@freezed
class WargaHomeState with _$WargaHomeState {
  const factory WargaHomeState({
    required bool isLoading,
    required Option<Failure> failure,
    required Option<List<Transaction>> transaction,
  }) = _WargaHomeState;

  factory WargaHomeState.initial() => WargaHomeState(
        isLoading: false,
        failure: none(),
        transaction: none(),
      );
}
