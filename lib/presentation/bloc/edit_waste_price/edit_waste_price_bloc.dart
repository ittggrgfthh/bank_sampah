import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/failures/failure.dart';
import '../../../core/utils/date_time_converter.dart';
import '../../../core/utils/number_converter.dart';
import '../../../domain/entities/user.dart';
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
        priceOrganic: NumberConverter.formatToThousandsInt(currentWastePrice.organic),
        priceInorganic: NumberConverter.formatToThousandsInt(currentWastePrice.inorganic),
        isChange: false,
        currentTimeAgo: DateTimeConverter.timeAgoFromMillisecond(currentWastePrice.createAt),
        currentAdminFullName: currentWastePrice.admin.id == user.id ? 'Anda' : currentWastePrice.admin.fullName!,
      )),
    );
  }

  Future<void> _handlePriceOrganicChanged(Emitter<EditWastePriceState> emit, String priceOrganic) async {
    state.wastePrice.fold(() => null, (wastePrice) {
      if (priceOrganic == wastePrice.organic.toString()) {
        emit(state.copyWith(isChange: false));
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
      if (priceInorganic == wastePrice.inorganic.toString()) {
        emit(state.copyWith(isChange: false));
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
    final admin = state.user.getOrElse(
      () => const User(
        id: 'id',
        phoneNumber: 'phoneNumber',
        role: 'admin',
        password: 'password',
      ),
    );
    final wastePrice = state.wastePrice.getOrElse(
      () => WastePrice(
        id: 'id',
        organic: 0,
        inorganic: 0,
        createAt: DateTime.now().millisecondsSinceEpoch,
        admin: admin,
      ),
    );
    final newWastePrice = wastePrice.copyWith(
      id: 'id',
      organic: NumberConverter.parseToInteger(state.priceOrganic),
      inorganic: NumberConverter.parseToInteger(state.priceInorganic),
      createAt: DateTime.now().millisecondsSinceEpoch,
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
        currentTimeAgo: DateTimeConverter.timeAgoFromMillisecond(newWastePrice.createAt),
        currentAdminFullName: 'Anda',
      )),
    );
  }
}
