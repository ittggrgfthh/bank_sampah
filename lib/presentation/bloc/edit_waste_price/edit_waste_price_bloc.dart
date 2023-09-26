import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/failures/failure.dart';
import '../../../core/utils/app_helper.dart';
import '../../../domain/entities/point_balance.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/waste.dart';
import '../../../domain/entities/waste_price.dart';
import '../../../domain/usecase/admin/create_waste_price.dart';
import '../../../domain/usecase/admin/get_current_waste_price.dart';

part 'edit_waste_price_bloc.freezed.dart';
part 'edit_waste_price_event.dart';
part 'edit_waste_price_state.dart';

class EditWastePriceBloc extends Bloc<EditWastePriceEvent, EditWastePriceState> {
  final GetCurrentWastePrice _getCurrentWastePrice;
  final CreateWastePrice _createWastePrice;

  EditWastePriceBloc(this._getCurrentWastePrice, this._createWastePrice) : super(EditWastePriceState.initial()) {
    on<EditWastePriceEvent>((event, emit) async {
      await event.when(
        initialized: (user) => _handleInitialized(emit, user),
        priceOrganicChanged: (priceOrganic) => _handlePriceOrganicChanged(emit, priceOrganic),
        priceInorganicChanged: (priceInorganic) => _handlePriceInorganicChanged(emit, priceInorganic),
        submitButtonPressed: () => _submitButtonPressed(emit),
      );
    });
  }

  Future<void> _handleInitialized(Emitter<EditWastePriceState> emit, User user) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 3));
    final failureOrSuccess = await _getCurrentWastePrice();
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        failure: optionOf(failure),
      )),
      (currentWastePrice) async => emit(state.copyWith(
        isLoading: false,
        failure: none(),
        user: optionOf(user),
        wastePrice: optionOf(currentWastePrice),
        priceOrganic: AppHelper.formatToThousandsInt(currentWastePrice.organic),
        priceInorganic: AppHelper.formatToThousandsInt(currentWastePrice.inorganic),
        isChange: false,
        currentTimeAgo: AppHelper.timeAgoFromMillisecond(currentWastePrice.createdAt),
        currentAdminFullName: currentWastePrice.admin.id == user.id ? 'Anda' : currentWastePrice.admin.fullName!,
      )),
    );
  }

  Future<void> _handlePriceOrganicChanged(Emitter<EditWastePriceState> emit, String priceOrganic) async {
    state.wastePrice.fold(() => null, (wastePrice) {
      if (priceOrganic == AppHelper.formatToThousandsInt(wastePrice.organic) &&
          state.priceInorganic == AppHelper.formatToThousandsInt(wastePrice.inorganic)) {
        emit(state.copyWith(
          priceOrganic: priceOrganic,
          isChange: false,
        ));
      } else {
        emit(state.copyWith(
          priceOrganic: priceOrganic,
          isChange: true,
        ));
      }
    });
  }

  Future<void> _handlePriceInorganicChanged(Emitter<EditWastePriceState> emit, String priceInorganic) async {
    state.wastePrice.fold(() => null, (wastePrice) {
      if (priceInorganic == AppHelper.formatToThousandsInt(wastePrice.inorganic) &&
          state.priceOrganic == AppHelper.formatToThousandsInt(wastePrice.organic)) {
        emit(state.copyWith(
          priceInorganic: priceInorganic,
          isChange: false,
        ));
      } else {
        emit(state.copyWith(
          priceInorganic: priceInorganic,
          isChange: true,
        ));
      }
    });
  }

  Future<void> _submitButtonPressed(Emitter<EditWastePriceState> emit) async {
    emit(state.copyWith(isLoading: true));

    final dateNowEpoch = DateTime.now().millisecondsSinceEpoch;

    final admin = state.user.getOrElse(
      () => User(
        id: 'id',
        phoneNumber: 'phoneNumber',
        role: 'admin',
        password: 'password',
        fullName: 'fullName',
        pointBalance: const PointBalance(
          userId: 'id',
          currentBalance: 0,
          waste: Waste(
            organic: 0,
            inorganic: 0,
          ),
        ),
        rt: 'rt',
        rw: 'rw',
        createdAt: dateNowEpoch,
        updatedAt: dateNowEpoch,
      ),
    );
    final wastePrice = state.wastePrice.getOrElse(
      () => WastePrice(
        id: 'id',
        organic: 0,
        inorganic: 0,
        createdAt: dateNowEpoch,
        admin: admin,
      ),
    );
    final newWastePrice = wastePrice.copyWith(
      id: 'id',
      organic: AppHelper.parseToInteger(state.priceOrganic),
      inorganic: AppHelper.parseToInteger(state.priceInorganic),
      createdAt: dateNowEpoch,
      admin: admin,
    );
    final failureOrSuccess = await _createWastePrice(newWastePrice);
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        failure: optionOf(failure),
      )),
      (_) => emit(state.copyWith(
        isLoading: false,
        wastePrice: optionOf(newWastePrice),
        failure: none(),
        isChange: false,
        currentTimeAgo: AppHelper.timeAgoFromMillisecond(newWastePrice.createdAt),
        currentAdminFullName: 'Anda',
      )),
    );
  }
}
