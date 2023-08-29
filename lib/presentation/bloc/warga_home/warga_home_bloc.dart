import 'package:bank_sampah/domain/usecase/get_user_by_id.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/failures/failure.dart';
import '../../../core/utils/number_converter.dart';
import '../../../domain/entities/transaction_waste.dart';
import '../../../domain/usecase/user/get_transactions_by_user_id.dart';

part 'warga_home_bloc.freezed.dart';
part 'warga_home_event.dart';
part 'warga_home_state.dart';

class WargaHomeBloc extends Bloc<WargaHomeEvent, WargaHomeState> {
  final GetTransactionsByUserId _getTransactionByUserId;
  final GetUserById _getUserById;
  WargaHomeBloc(this._getTransactionByUserId, this._getUserById) : super(WargaHomeState.initial()) {
    on<WargaHomeEvent>((event, emit) async {
      await event.when(
        initialized: (userId) => _handleInitialized(emit, userId),
      );
    });
  }

  Future<void> _handleInitialized(Emitter<WargaHomeState> emit, String userId) async {
    emit(state.copyWith(isLoading: true));

    final failureOrSuccessUser = await _getUserById(userId);
    final userOption = failureOrSuccessUser.getRight();
    final user = userOption.toNullable();

    final failureOrSuccess = await _getTransactionByUserId(userId);
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        failure: optionOf(failure),
      )),
      (transactions) {
        if (user != null) {
          final totalOrganic = user.pointBalance.waste.organic;
          final totalInorganic = user.pointBalance.waste.inorganic;
          final totalWasteStored = totalOrganic + totalInorganic;
          emit(state.copyWith(
            totalBalance: NumberConverter.formatToThousandsInt(user.pointBalance.currentBalance),
            totalOrganic: NumberConverter.formatToThousandsInt(totalOrganic),
            totalInorganic: NumberConverter.formatToThousandsInt(totalInorganic),
            totalWasteStored: NumberConverter.formatToThousandsInt(totalWasteStored),
          ));
        }
        emit(state.copyWith(
          isLoading: false,
          failure: none(),
          transactionwaste: optionOf(transactions),
        ));
      },
    );
  }
}
