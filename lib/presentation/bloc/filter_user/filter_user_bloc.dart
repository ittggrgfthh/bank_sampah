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
        filterLoaded: () => _handleLoadFilter(emit),
        filterSaved: (filter) => _handleSaveFilter(emit, filter),
        filterCleared: () => _handleClearFilter(emit),
      );
    });
  }

  Future<void> _handleLoadFilter(Emitter<FilterUserState> emit) async {
    final failureOrSuccess = await _getUserFilter();
    failureOrSuccess.fold(
      (failure) => emit(const FilterUserState.error('Gagal memuat filter')),
      (filter) => emit(FilterUserState.loaded(filter)),
    );
    print(state);
  }

  Future<void> _handleSaveFilter(Emitter<FilterUserState> emit, FilterUser filter) async {
    final failureOrSuccess = await _saveUserFilter(filter);
    failureOrSuccess.fold(
      (faiure) => emit(const FilterUserState.error('Gagal menyimpan filter')),
      (_) => emit(FilterUserState.loaded(filter)),
    );

    print(filter);
  }

  Future<void> _handleClearFilter(Emitter<FilterUserState> emit) async {
    emit(const FilterUserState.initial());
  }
}
