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
import '../../../domain/usecase/admin/get_current_waste_price.dart';
import '../../../domain/usecase/auth/get_user_by_id.dart';
import '../../../domain/usecase/staff/create_waste_transaction.dart';

part 'store_waste_form_bloc.freezed.dart';
part 'store_waste_form_event.dart';
part 'store_waste_form_state.dart';

class StoreWasteFormBloc extends Bloc<StoreWasteFormEvent, StoreWasteFormState> {
  final GetCurrentWastePrice _getCurrentWastePrice;
  final CreateWasteTransaction _createWasteTransaction;
  final GetUserById _getUserById;
  StoreWasteFormBloc(
    this._getCurrentWastePrice,
    this._createWasteTransaction,
    this._getUserById,
  ) : super(StoreWasteFormState.initial()) {
    on<StoreWasteFormEvent>((event, emit) async {
      await event.when(
        initialized: (userId, staff) => _handleInitialized(emit, userId, staff),
        organicWeightChanged: (organicWeight) => _handleOrganicWeightChanged(emit, organicWeight),
        inorganicWeightChanged: (inorganicWeight) => _handleInorganicWeightChanged(emit, inorganicWeight),
        submitButtonPressed: () => _submitButtonPressed(emit),
      );
    });
  }

  Future<void> _handleInitialized(Emitter<StoreWasteFormState> emit, String userId, User staff) async {
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
      )),
    );

    if (failureOrSuccessUser.isLeft()) {
      return;
    }

    final user = state.user.toNullable();

    if (user == null) {
      return;
    }

    final defaultTransaction = DefaultData.transactionWaste.copyWith(
      staff: staff,
      user: user,
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
        priceInorganic: AppHelper.formatToThousandsInt(currentWastePrice.inorganic),
        priceOrganic: AppHelper.formatToThousandsInt(currentWastePrice.organic),
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
    final priceOrganicInt = AppHelper.parseToInteger(state.priceOrganic);
    final priceInorganicInt = AppHelper.parseToInteger(state.priceInorganic);

    final organicWeightInt = AppHelper.parseToInteger(organicWeight);
    final inorganicWeightInt = AppHelper.parseToInteger(inorganicWeight);

    final newEarnedBalance = (priceOrganicInt * organicWeightInt) + (priceInorganicInt * inorganicWeightInt);
    return AppHelper.formatToThousandsInt(newEarnedBalance);
  }

  Future<void> _handleOrganicWeightChanged(Emitter<StoreWasteFormState> emit, String organicWeight) async {
    emit(state.copyWith(
      organicWeight: organicWeight,
      earnedBalance: _earnedBalance(organicWeight: organicWeight, inorganicWeight: state.inorganicWeight),
      isChanged: organicWeight != "0" || state.inorganicWeight != "0",
    ));
  }

  Future<void> _handleInorganicWeightChanged(Emitter<StoreWasteFormState> emit, String inorganicWeight) async {
    emit(state.copyWith(
      inorganicWeight: inorganicWeight,
      earnedBalance: _earnedBalance(organicWeight: state.organicWeight, inorganicWeight: inorganicWeight),
      isChanged: state.organicWeight != "0" || inorganicWeight != "0",
    ));
  }

  User _newUser({
    required TransactionWaste transaction,
    required String earnedBalance,
    required String organicWeight,
    required String inorganicWeight,
    required int lastTransactionEpoch,
  }) {
    return transaction.user.copyWith(
      pointBalance: PointBalance(
        userId: transaction.user.id,
        currentBalance: transaction.user.pointBalance.currentBalance + AppHelper.parseToInteger(earnedBalance),
        waste: Waste(
          organic: transaction.user.pointBalance.waste.organic + AppHelper.parseToInteger(organicWeight),
          inorganic: transaction.user.pointBalance.waste.inorganic + AppHelper.parseToInteger(inorganicWeight),
        ),
      ),
      lastTransactionEpoch: lastTransactionEpoch,
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
        lastTransactionEpoch: dateNowEpoch,
      ),
      storeWaste: _newStoreWaste(
        organicWeight: state.organicWeight,
        inorganicWeight: state.inorganicWeight,
        priceOrganic: state.priceOrganic,
        priceInorganic: state.priceInorganic,
        wastePrice: transaction.storeWaste!.wastePrice,
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
        isChanged: false,
        transaction: optionOf(newTransaction),
        failureOrSuccessOption: optionOf(failureOrSuccess),
        organicWeight: '0',
        earnedBalance: '0',
        inorganicWeight: '0',
      )),
    );
  }
}
