import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/filter_user.dart';
import '../../../domain/usecase/usecase.dart';

part 'filter_user_bloc.freezed.dart';
part 'filter_user_event.dart';
part 'filter_user_state.dart';

class FilterUserBloc extends Bloc<FilterUserEvent, FilterUserState> {
  final GetUserFilter _getUserFilter;
  final SaveUserFilter _saveUserFilter;
  FilterUserBloc(
    this._getUserFilter,
    this._saveUserFilter,
  ) : super(const FilterUserState.initial()) {
    on<FilterUserEvent>((event, emit) async {
      await event.when(
        loaded: () => _handleLoaded(emit),
        apply: (filter) => _handleApply(emit, filter),
        reset: () => _handleReset(emit),
      );
    });
  }

  Future<void> _handleLoaded(Emitter<FilterUserState> emit) async {
    emit(const FilterUserState.loadInProgress());
    final failureOrSuccess = await _getUserFilter();
    failureOrSuccess.fold(
      (failure) => emit(const FilterUserState.loadFailure('Gagal memuat filter')),
      (filter) => emit(FilterUserState.loadSuccess(filter)),
    );
    print(state);
  }

  Future<void> _handleApply(Emitter<FilterUserState> emit, FilterUser filter) async {
    emit(const FilterUserState.loadInProgress());
    final failureOrSuccess = await _saveUserFilter(filter);
    failureOrSuccess.fold(
      (faiure) => emit(const FilterUserState.loadFailure('Gagal menyimpan filter')),
      (_) => emit(FilterUserState.loadSuccess(filter)),
    );
    print(filter);
  }

  Future<void> _handleReset(Emitter<FilterUserState> emit) async {
    emit(const FilterUserState.loadInProgress());
    emit(const FilterUserState.initial());
  }
}
