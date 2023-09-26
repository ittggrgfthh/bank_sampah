import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/failures/failure.dart';
import '../../../domain/entities/filter_transaction_waste.dart';
import '../../../domain/entities/transaction_waste.dart';
import '../../../domain/usecase/get_transactions_filter.dart';

part 'transaction_history_bloc.freezed.dart';
part 'transaction_history_event.dart';
part 'transaction_history_state.dart';

class TransactionHistoryBloc extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  final GetTransactionsFilter _getTransactionsFilter;
  TransactionHistoryBloc(this._getTransactionsFilter) : super(const TransactionHistoryState.initial()) {
    on<TransactionHistoryEvent>((event, emit) async {
      await event.when(
        filterChanged: (filter) => _handleFilterChanged(emit, filter),
      );
    });
  }

  Future<void> _handleFilterChanged(Emitter<TransactionHistoryState> emit, FilterTransactionWaste filter) async {
    emit(const TransactionHistoryState.loadInProgress());
    final failureOrSuccess = await _getTransactionsFilter(filter);
    failureOrSuccess.fold(
      (failure) => emit(TransactionHistoryState.loadFailure(failure)),
      (transactions) => emit(TransactionHistoryState.loadSuccess(transactions)),
    );
  }
}
