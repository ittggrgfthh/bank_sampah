import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constant/default_data.dart';
import '../../../core/failures/failure.dart';
import '../../../core/utils/number_converter.dart';
import '../../../domain/entities/point_balance.dart';
import '../../../domain/entities/transaction_waste.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/waste.dart';
import '../../../domain/usecase/staff/update_waste_transaction.dart';

part 'edit_store_waste_form_bloc.freezed.dart';
part 'edit_store_waste_form_event.dart';
part 'edit_store_waste_form_state.dart';

class EditStoreWasteFormBloc extends Bloc<EditStoreWasteFormEvent, EditStoreWasteFormState> {
  final UpdateWasteTransaction _updateWasteTransaction;
  EditStoreWasteFormBloc(this._updateWasteTransaction) : super(EditStoreWasteFormState.initial()) {
    on<EditStoreWasteFormEvent>((event, emit) async {
      await event.when(
        initialized: (transactionWaste) => _handleInitialized(emit, transactionWaste),
        organicWeightChanged: (organicWeight) => _handleOrganicWeightChanged(emit, organicWeight),
        inorganicWeightChanged: (inorganicWeight) => _handleInorganicWeightChanged(emit, inorganicWeight),
        submitButtonPressed: () => _submitButtonPressed(emit),
      );
    });
  }

  Future<void> _handleInitialized(Emitter<EditStoreWasteFormState> emit, TransactionWaste transactionWaste) async {
    emit(state.copyWith(isLoading: true));

    if (transactionWaste.storeWaste == null) {
      emit(state.copyWith(
        isLoading: false,
        failure: optionOf(const Failure.unexpected('Store Waste tidak ada.')),
      ));
    }
    emit(state.copyWith(
      isLoading: false,
      transaction: optionOf(transactionWaste),
      priceOrganic: NumberConverter.formatToThousandsInt(transactionWaste.storeWaste!.wastePrice.organic),
      priceInorganic: NumberConverter.formatToThousandsInt(transactionWaste.storeWaste!.wastePrice.inorganic),
      organicWeight: NumberConverter.formatToThousandsInt(transactionWaste.storeWaste!.waste.organic),
      inorganicWeight: NumberConverter.formatToThousandsInt(transactionWaste.storeWaste!.waste.inorganic),
      earnedBalance: NumberConverter.formatToThousandsInt(transactionWaste.storeWaste!.earnedBalance),
      isChange: false,
      failureOrSuccessOption: none(),
    ));
  }

  String _earnedBalance({
    required String organicWeight,
    required String inorganicWeight,
  }) {
    final priceOrganicInt = NumberConverter.parseToInteger(state.priceOrganic);
    final priceInorganicInt = NumberConverter.parseToInteger(state.priceInorganic);

    final organicWeightInt = NumberConverter.parseToInteger(organicWeight);
    final inorganicWeightInt = NumberConverter.parseToInteger(inorganicWeight);

    final newEarnedBalance = (priceOrganicInt * organicWeightInt) + (priceInorganicInt * inorganicWeightInt);
    return NumberConverter.formatToThousandsInt(newEarnedBalance);
  }

  Future<void> _handleOrganicWeightChanged(Emitter<EditStoreWasteFormState> emit, String organicWeight) async {
    final transaction = state.transaction.toNullable();

    if (transaction != null) {
      final beforeOrganicWeight = NumberConverter.formatToThousandsInt(transaction.storeWaste!.waste.organic);
      final beforeInorganicWeight = NumberConverter.formatToThousandsInt(transaction.storeWaste!.waste.inorganic);
      emit(state.copyWith(
        organicWeight: organicWeight,
        earnedBalance: _earnedBalance(organicWeight: organicWeight, inorganicWeight: state.inorganicWeight),
        isChange: organicWeight != beforeOrganicWeight || state.inorganicWeight != beforeInorganicWeight,
      ));
    } else {
      emit(state.copyWith(
        organicWeight: organicWeight,
        earnedBalance: _earnedBalance(organicWeight: organicWeight, inorganicWeight: state.inorganicWeight),
        isChange: organicWeight != "0" || state.inorganicWeight != "0",
      ));
    }
  }

  Future<void> _handleInorganicWeightChanged(Emitter<EditStoreWasteFormState> emit, String inorganicWeight) async {
    final transaction = state.transaction.toNullable();

    if (transaction != null) {
      final beforeOrganicWeight = NumberConverter.formatToThousandsInt(transaction.storeWaste!.waste.organic);
      final beforeInorganicWeight = NumberConverter.formatToThousandsInt(transaction.storeWaste!.waste.inorganic);
      emit(state.copyWith(
        inorganicWeight: inorganicWeight,
        earnedBalance: _earnedBalance(organicWeight: state.organicWeight, inorganicWeight: inorganicWeight),
        isChange: state.organicWeight != beforeOrganicWeight || inorganicWeight != beforeInorganicWeight,
      ));
    } else {
      emit(state.copyWith(
        inorganicWeight: inorganicWeight,
        earnedBalance: _earnedBalance(organicWeight: state.organicWeight, inorganicWeight: inorganicWeight),
        isChange: state.organicWeight != "0" || inorganicWeight != "0",
      ));
    }
  }

  User _newUser({
    required TransactionWaste transaction,
    required String earnedBalance,
    required String organicWeight,
    required String inorganicWeight,
  }) {
    return transaction.user.copyWith(
      pointBalance: PointBalance(
        userId: transaction.user.id,
        currentBalance: transaction.user.pointBalance.currentBalance +
            NumberConverter.parseToInteger(earnedBalance) -
            transaction.storeWaste!.earnedBalance,
        waste: Waste(
          organic: transaction.user.pointBalance.waste.organic +
              NumberConverter.parseToInteger(organicWeight) -
              transaction.storeWaste!.waste.organic,
          inorganic: transaction.user.pointBalance.waste.inorganic +
              NumberConverter.parseToInteger(inorganicWeight) -
              transaction.storeWaste!.waste.inorganic,
        ),
      ),
    );
  }

  Future<void> _submitButtonPressed(Emitter<EditStoreWasteFormState> emit) async {
    emit(state.copyWith(isLoading: true));
    final dateNowEpoch = DateTime.now().millisecondsSinceEpoch;

    final transaction = state.transaction.getOrElse(() => DefaultData.transactionWaste);

    final newTransaction = transaction.copyWith(
      updatedAt: dateNowEpoch,
      user: _newUser(
        transaction: transaction,
        earnedBalance: state.earnedBalance,
        organicWeight: state.organicWeight,
        inorganicWeight: state.inorganicWeight,
      ),
      storeWaste: StoreWaste(
        earnedBalance: NumberConverter.parseToInteger(state.earnedBalance),
        waste: Waste(
          organic: NumberConverter.parseToInteger(state.organicWeight),
          inorganic: NumberConverter.parseToInteger(state.inorganicWeight),
        ),
        wastePrice: transaction.storeWaste!.wastePrice, // karena storeWaste bisa null
      ),
      withdrawnBalance: null,
      historyUpdate: [
        HistoryWaste(
          storeWaste: transaction.storeWaste!,
          updatedAt: dateNowEpoch,
        ),
        ...transaction.historyUpdate,
      ],
    );

    final failureOrSuccess = await _updateWasteTransaction(newTransaction);
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        failure: optionOf(failure),
      )),
      (_) => emit(state.copyWith(
        isLoading: false,
        failure: none(),
        isChange: false,
        transaction: optionOf(newTransaction),
        failureOrSuccessOption: optionOf(failureOrSuccess),
        organicWeight: '0',
        earnedBalance: '0',
        inorganicWeight: '0',
      )),
    );
  }
}
