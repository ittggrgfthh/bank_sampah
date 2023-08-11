part of 'withdraw_balance_form_bloc.dart';

@freezed
class WithdrawBalanceFormState with _$WithdrawBalanceFormState {
  const factory WithdrawBalanceFormState({
    required bool isLoading,
    required bool isChanged,
    required Option<Failure> failure,
    required Option<TransactionWaste> transaction,
    required int currentBalance,
    required String withdrwaBalance,
    required Option<String> withdrwaBalanceValidator,
    required int withdrawBalanceChoice,
    required Option<Either<Failure, Unit>> failureOrSuccessOption,
  }) = _WithdrawBalanceFormState;

  factory WithdrawBalanceFormState.initial() => WithdrawBalanceFormState(
        isLoading: false,
        isChanged: false,
        failure: none(),
        transaction: none(),
        currentBalance: 0,
        withdrwaBalance: '0',
        withdrwaBalanceValidator: none(),
        withdrawBalanceChoice: 0,
        failureOrSuccessOption: none(),
      );
}
