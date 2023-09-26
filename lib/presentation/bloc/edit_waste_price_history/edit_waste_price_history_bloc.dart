import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/failures/failure.dart';
import '../../../domain/entities/waste_price.dart';
import '../../../domain/usecase/admin/get_waste_prices.dart';

part 'edit_waste_price_history_bloc.freezed.dart';
part 'edit_waste_price_history_event.dart';
part 'edit_waste_price_history_state.dart';

class EditWastePriceHistoryBloc extends Bloc<EditWastePriceHistoryEvent, EditWastePriceHistoryState> {
  final GetWastePrices _getWastePrices;
  EditWastePriceHistoryBloc(this._getWastePrices) : super(const EditWastePriceHistoryState.initial()) {
    on<EditWastePriceHistoryEvent>((event, emit) async {
      await event.when(
        initialized: () => _handleInitialized(emit),
      );
    });
  }

  Future<void> _handleInitialized(Emitter<EditWastePriceHistoryState> emit) async {
    emit(const EditWastePriceHistoryState.loadInProgress());
    final failureOrSuccess = await _getWastePrices();
    failureOrSuccess.fold(
      (failure) => emit(EditWastePriceHistoryState.loadFailure(failure)),
      (wastePrices) => emit(EditWastePriceHistoryState.loadSuccess(wastePrices)),
    );
  }
}
