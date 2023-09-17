part of 'filter_user_bloc.dart';

@freezed
class FilterUserState with _$FilterUserState {
  const factory FilterUserState.initial() = _Initial;
  const factory FilterUserState.loaded(FilterUser filter) = _Loaded;
  const factory FilterUserState.error(String message) = _Error;
}
