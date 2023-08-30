import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constant/default_data.dart';
import '../../../core/failures/failure.dart';
import '../../../core/utils/app_helper.dart';
import '../../../domain/entities/point_balance.dart';
import '../../../domain/entities/transaction_waste.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/waste.dart';
import '../../../domain/entities/waste_price.dart';
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
      priceOrganic: AppHelper.formatToThousandsInt(transactionWaste.storeWaste!.wastePrice.organic),
      priceInorganic: AppHelper.formatToThousandsInt(transactionWaste.storeWaste!.wastePrice.inorganic),
      organicWeight: AppHelper.formatToThousandsInt(transactionWaste.storeWaste!.waste.organic),
      inorganicWeight: AppHelper.formatToThousandsInt(transactionWaste.storeWaste!.waste.inorganic),
      earnedBalance: AppHelper.formatToThousandsInt(transactionWaste.storeWaste!.earnedBalance),
      isChange: false,
      failureOrSuccessOption: none(),
    ));
  }

  String _earnedBalance({
    required String organicWeight,
    required String inorganicWeight,
  }) {
    final priceOrganicInt = AppHelper.parseToInteger(state.priceOrganic);
    final priceInorganicInt = AppHelper.parseToInteger(state.priceInorganic);

    final organicWeightInt = AppHelper.parseToInteger(organicWeight);
    final inorganicWeightInt = AppHelper.parseToInteger(inorganicWeight);

    final newEarnedBalance = (priceOrganicInt * organicWeightInt) + (priceInorganicInt * inorganicWeightInt);
    return AppHelper.formatToThousandsInt(newEarnedBalance);
  }

  Future<void> _handleOrganicWeightChanged(Emitter<EditStoreWasteFormState> emit, String organicWeight) async {
    final transaction = state.transaction.toNullable();

    if (transaction != null) {
      final beforeOrganicWeight = AppHelper.formatToThousandsInt(transaction.storeWaste!.waste.organic);
      final beforeInorganicWeight = AppHelper.formatToThousandsInt(transaction.storeWaste!.waste.inorganic);
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
      final beforeOrganicWeight = AppHelper.formatToThousandsInt(transaction.storeWaste!.waste.organic);
      final beforeInorganicWeight = AppHelper.formatToThousandsInt(transaction.storeWaste!.waste.inorganic);
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
            AppHelper.parseToInteger(earnedBalance) -
            transaction.storeWaste!.earnedBalance,
        waste: Waste(
          organic: transaction.user.pointBalance.waste.organic +
              AppHelper.parseToInteger(organicWeight) -
              transaction.storeWaste!.waste.organic,
          inorganic: transaction.user.pointBalance.waste.inorganic +
              AppHelper.parseToInteger(inorganicWeight) -
              transaction.storeWaste!.waste.inorganic,
        ),
      ),
    );
  }

  StoreWaste _newStoreWaste({
    required String organicWeight,
    required String inorganicWeight,
    required String priceOrganic,
    required String priceInorganic,
    required WastePrice wastePrice,
  }) {
    int organicWeightInt = AppHelper.parseToInteger(organicWeight);
    int inorganicWeightInt = AppHelper.parseToInteger(inorganicWeight);
    int priceOrganicInt = AppHelper.parseToInteger(priceOrganic);
    int priceInorganicInt = AppHelper.parseToInteger(priceInorganic);

    int organicBalanceInt = organicWeightInt * priceOrganicInt;
    int inorganicBalanceInt = inorganicWeightInt * priceInorganicInt;
    int earnedBalanceInt = organicBalanceInt + inorganicBalanceInt;

    return StoreWaste(
      earnedBalance: earnedBalanceInt,
      // Kg
      waste: Waste(
        organic: organicWeightInt,
        inorganic: inorganicWeightInt,
      ),
      // Rp
      wasteBalance: Waste(
        organic: organicBalanceInt,
        inorganic: inorganicBalanceInt,
      ),
      wastePrice: wastePrice, // karena storeWaste bisa null
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
      storeWaste: _newStoreWaste(
        organicWeight: state.organicWeight,
        inorganicWeight: state.inorganicWeight,
        priceOrganic: state.priceOrganic,
        priceInorganic: state.priceInorganic,
        wastePrice: transaction.storeWaste!.wastePrice,
      ),
      withdrawnBalance: null,
      historyStoreWaste: [
        HistoryStoreWaste(
          storeWaste: transaction.storeWaste!,
          updatedAt: dateNowEpoch,
        ),
        ...transaction.historyStoreWaste,
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
