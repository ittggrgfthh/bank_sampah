import 'package:bank_sampah/domain/entities/transaction_waste.dart';
import 'package:bank_sampah/domain/entities/waste.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constant/default_data.dart';
import '../../../core/failures/failure.dart';
import '../../../core/utils/number_converter.dart';
import '../../../domain/entities/point_balance.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecase/admin/get_current_waste_price.dart';
import '../../../domain/usecase/staff/create_waste_transaction.dart';

part 'store_waste_form_event.dart';
part 'store_waste_form_state.dart';
part 'store_waste_form_bloc.freezed.dart';

class StoreWasteFormBloc extends Bloc<StoreWasteFormEvent, StoreWasteFormState> {
  final GetCurrentWastePrice _getCurrentWastePrice;
  final CreateWasteTransaction _createWasteTransaction;
  StoreWasteFormBloc(
    this._getCurrentWastePrice,
    this._createWasteTransaction,
  ) : super(StoreWasteFormState.initial()) {
    on<StoreWasteFormEvent>((event, emit) async {
      await event.when(
        initialized: (user, staff) => _handleInitialized(emit, user, staff),
        organicWeightChanged: (organicWeight) => _handleOrganicWeightChanged(emit, organicWeight),
        inorganicWeightChanged: (inorganicWeight) => _handleInorganicWeightChanged(emit, inorganicWeight),
        submitButtonPressed: () => _submitButtonPressed(emit),
      );
    });
  }

  Future<void> _handleInitialized(Emitter<StoreWasteFormState> emit, User user, User staff) async {
    emit(state.copyWith(isLoading: true));
    final defaultTransaction = DefaultData.transactionWaste.copyWith(
      user: user,
      staff: staff,
    );
    final failureOrSuccess = await _getCurrentWastePrice();
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        failure: optionOf(failure),
      )),
      (currentWastePrice) async => emit(state.copyWith(
        isLoading: false,
        failure: none(),
        priceInorganic: NumberConverter.formatToThousandsInt(currentWastePrice.organic),
        priceOrganic: NumberConverter.formatToThousandsInt(currentWastePrice.inorganic),
        transaction: optionOf(defaultTransaction.copyWith.storeWaste?.call(
          wastePrice: currentWastePrice,
        )),
      )),
    );
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

  Future<void> _handleOrganicWeightChanged(Emitter<StoreWasteFormState> emit, String organicWeight) async {
    emit(state.copyWith(
      organicWeight: organicWeight,
      earnedBalance: _earnedBalance(organicWeight: organicWeight, inorganicWeight: state.inorganicWeight),
      isChange: organicWeight != "0" || state.inorganicWeight != "0",
    ));
  }

  Future<void> _handleInorganicWeightChanged(Emitter<StoreWasteFormState> emit, String inorganicWeight) async {
    emit(state.copyWith(
      inorganicWeight: inorganicWeight,
      earnedBalance: _earnedBalance(organicWeight: state.organicWeight, inorganicWeight: inorganicWeight),
      isChange: state.organicWeight != "0" || inorganicWeight != "0",
    ));
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
        currentBalance: transaction.user.pointBalance.currentBalance + NumberConverter.parseToInteger(earnedBalance),
        waste: Waste(
          organic: transaction.user.pointBalance.waste.organic + NumberConverter.parseToInteger(organicWeight),
          inorganic: transaction.user.pointBalance.waste.inorganic + NumberConverter.parseToInteger(inorganicWeight),
        ),
      ),
    );
  }

  Future<void> _submitButtonPressed(Emitter<StoreWasteFormState> emit) async {
    emit(state.copyWith(isLoading: true));
    final dateNowEpoch = DateTime.now().millisecondsSinceEpoch;

    final transaction = state.transaction.getOrElse(() => DefaultData.transactionWaste);

    final newTransaction = transaction.copyWith(
      createdAt: dateNowEpoch,
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
      withdrawnBalance: null, // null: karena ini bukan transaksi tarik saldo
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
