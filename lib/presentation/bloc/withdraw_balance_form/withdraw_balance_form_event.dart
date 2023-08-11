part of 'withdraw_balance_form_bloc.dart';

@freezed
class WithdrawBalanceFormEvent with _$WithdrawBalanceFormEvent {
  const factory WithdrawBalanceFormEvent.initialized(User user, User staff) = _Initialized;
  const factory WithdrawBalanceFormEvent.withdrwaBalanceChanged(String withdrwaBalance) = _WithdrwaBalanceChanged;
  const factory WithdrawBalanceFormEvent.withdrawBalanceChoiceChanged(int withdrawBalanceChoice) =
      _WithdrawBalanceChoiceChanged;
  const factory WithdrawBalanceFormEvent.submitButtonPressed() = _SubmitButtonPressed;
}
