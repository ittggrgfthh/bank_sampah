import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constant/default_data.dart';
import '../../../core/failures/failure.dart';
import '../../../core/utils/app_helper.dart';
import '../../../domain/entities/transaction_waste.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecase/auth/get_user_by_id.dart';
import '../../../domain/usecase/staff/create_waste_transaction.dart';

part 'withdraw_balance_form_bloc.freezed.dart';
part 'withdraw_balance_form_event.dart';
part 'withdraw_balance_form_state.dart';

class WithdrawBalanceFormBloc extends Bloc<WithdrawBalanceFormEvent, WithdrawBalanceFormState> {
  final CreateWasteTransaction _createWasteTransaction;
  final GetUserById _getUserById;
  WithdrawBalanceFormBloc(
    this._createWasteTransaction,
    this._getUserById,
  ) : super(WithdrawBalanceFormState.initial()) {
    on<WithdrawBalanceFormEvent>((event, emit) async {
      await event.when(
        initialized: (userId, staff) => _handleInitialized(emit, userId, staff),
        withdrawBalanceChoiceChanged: (withdrawBalanceChoice) =>
            _handleWithdrawBalanceChoiceChanged(emit, withdrawBalanceChoice),
        withdrwaBalanceChanged: (withdrwaBalance) => _handleWithdrwaBalanceChanged(emit, withdrwaBalance),
        submitButtonPressed: () => _submitButtonPressed(emit),
      );
    });
  }

  Future<void> _handleInitialized(Emitter<WithdrawBalanceFormState> emit, String userId, User staff) async {
    emit(state.copyWith(isLoading: true));
    final failureOrSuccessUser = await _getUserById(userId);

    failureOrSuccessUser.fold(
        (failure) => emit(state.copyWith(
              isLoading: false,
              failure: optionOf(failure),
            )),
        (user) => emit(state.copyWith(
              isLoading: false,
              user: optionOf(user),
            )));

    if (failureOrSuccessUser.isLeft()) {
      return;
    }

    final user = state.user.toNullable();

    if (user == null) {
      return;
    }

    final defaultTransaction = DefaultData.transactionWaste.copyWith(
      user: user,
      staff: staff,
    );

    emit(state.copyWith(
      isLoading: false,
      transaction: optionOf(defaultTransaction),
      currentBalance: user.pointBalance.currentBalance,
    ));
  }

  Future<void> _handleWithdrawBalanceChoiceChanged(
    Emitter<WithdrawBalanceFormState> emit,
    int withdrawBalanceChoice,
  ) async {
    emit(state.copyWith(
      withdrawBalanceChoice: withdrawBalanceChoice,
      isChanged: withdrawBalanceChoice > 0,
    ));
  }

  Future<void> _handleWithdrwaBalanceChanged(
    Emitter<WithdrawBalanceFormState> emit,
    String withdrwaBalance,
  ) async {
    int withdrwaBalanceInt = AppHelper.parseToInteger(withdrwaBalance);
    if (withdrwaBalanceInt > state.currentBalance) {
      emit(state.copyWith(
        withdrwaBalanceValidator:
            optionOf('Saldo tidak mencukupi, minimal Rp${AppHelper.formatToThousandsInt(state.currentBalance)}!'),
        isChanged: false,
        withdrwaBalance: withdrwaBalance,
      ));
    } else {
      emit(state.copyWith(
        withdrwaBalanceValidator: none(),
        withdrwaBalance: withdrwaBalance,
        isChanged: withdrwaBalance != '0',
      ));
    }
  }

  Future<void> _submitButtonPressed(Emitter<WithdrawBalanceFormState> emit) async {
    emit(state.copyWith(isLoading: true));
    final dateNowEpoch = DateTime.now().millisecondsSinceEpoch;
    final transaction = state.transaction.getOrElse(() => DefaultData.transactionWaste);

    int withdrwaBalance = AppHelper.parseToInteger(state.withdrwaBalance);
    if (state.withdrwaBalance == '0') {
      withdrwaBalance = state.withdrawBalanceChoice;
    }

    final currentBalance = transaction.user.pointBalance.currentBalance;

    final newTransaction = transaction.copyWith(
      createdAt: dateNowEpoch,
      updatedAt: dateNowEpoch,
      user: transaction.user.copyWith.pointBalance(
        userId: transaction.user.id,
        currentBalance: currentBalance - withdrwaBalance,
      ),
      storeWaste: null,
      withdrawnBalance: WithdrawnBalance(
        balance: currentBalance,
        withdrawn: withdrwaBalance,
        currentBalance: currentBalance - withdrwaBalance,
      ),
    );
    final failureOrSuccess = await _createWasteTransaction(newTransaction);
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        failure: optionOf(failure),
      )),
      (_) => emit(state.copyWith(
        isLoading: false,
        failure: none(),
        transaction: optionOf(newTransaction),
        failureOrSuccessOption: optionOf(failureOrSuccess),
        withdrwaBalance: '0',
        withdrawBalanceChoice: 0,
      )),
    );
  }
}
