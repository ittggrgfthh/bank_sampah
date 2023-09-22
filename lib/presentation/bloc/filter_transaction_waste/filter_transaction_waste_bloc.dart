import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/filter_transaction_waste.dart';
import '../../../domain/usecase/transaction/get_transaction_waste_filter.dart';
import '../../../domain/usecase/transaction/save_transaction_waste_filter.dart';

part 'filter_transaction_waste_bloc.freezed.dart';
part 'filter_transaction_waste_event.dart';
part 'filter_transaction_waste_state.dart';

class FilterTransactionWasteBloc extends Bloc<FilterTransactionWasteEvent, FilterTransactionWasteState> {
  final GetTransactionWasteFilter _getTransactionWasteFilter;
  final SaveTransactionWasteFilter _saveTransactionWasteFilter;
  FilterTransactionWasteBloc(this._getTransactionWasteFilter, this._saveTransactionWasteFilter)
      : super(const FilterTransactionWasteState.initial()) {
    on<FilterTransactionWasteEvent>((event, emit) async {
      await event.when(
        loaded: () => _handleLoaded(emit),
        apply: (filter) => _handleApply(emit, filter),
        reset: () => _handleReset(emit),
      );
    });
  }

  Future<void> _handleLoaded(Emitter<FilterTransactionWasteState> emit) async {
    emit(const FilterTransactionWasteState.loadInProgress());
    final failureOrSuccess = await _getTransactionWasteFilter();
    failureOrSuccess.fold(
      (failure) => emit(const FilterTransactionWasteState.loadFailure('Gagal memuat filter')),
      (filter) => emit(FilterTransactionWasteState.loadSuccess(filter)),
    );
  }

  Future<void> _handleApply(Emitter<FilterTransactionWasteState> emit, FilterTransactionWaste filter) async {
    emit(const FilterTransactionWasteState.loadInProgress());
    final failureOrSuccess = await _saveTransactionWasteFilter(filter);
    failureOrSuccess.fold(
      (faiure) => emit(const FilterTransactionWasteState.loadFailure('Gagal menyimpan filter')),
      (_) => emit(FilterTransactionWasteState.loadSuccess(filter)),
    );
  }

  Future<void> _handleReset(Emitter<FilterTransactionWasteState> emit) async {
    emit(const FilterTransactionWasteState.loadInProgress());
    emit(const FilterTransactionWasteState.initial());
  }
}
