import 'package:bank_sampah/domain/usecase/staff/get_transactions_by_staff_id.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/failures/failure.dart';
import '../../../domain/entities/transaction_waste.dart';

part 'transaction_history_event.dart';
part 'transaction_history_state.dart';
part 'transaction_history_bloc.freezed.dart';

class TransactionHistoryBloc extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  final GetTransactionsByStaffId _getTransactionsByStaffId;
  TransactionHistoryBloc(this._getTransactionsByStaffId) : super(const TransactionHistoryState.initial()) {
    on<TransactionHistoryEvent>((event, emit) async {
      await event.when(
        initialized: (staffId) => _handleInitialized(emit, staffId),
      );
    });
  }

  Future<void> _handleInitialized(Emitter<TransactionHistoryState> emit, String staffId) async {
    emit(const TransactionHistoryState.loadInProgress());
    final failureOrSuccess = await _getTransactionsByStaffId(staffId);
    failureOrSuccess.fold(
      (failure) => emit(TransactionHistoryState.loadFailure(failure)),
      (transactions) => emit(TransactionHistoryState.loadSuccess(transactions)),
    );
  }
}
