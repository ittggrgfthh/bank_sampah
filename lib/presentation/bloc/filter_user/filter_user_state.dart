part of 'filter_user_bloc.dart';

@freezed
class FilterUserState with _$FilterUserState {
  const factory FilterUserState.initial() = _Initial;
  const factory FilterUserState.loadInProgress() = _LoadInProgress;
  const factory FilterUserState.loadSuccess(FilterUser filter) = _LoadSuccess;
  const factory FilterUserState.loadFailure(String message) = _LoadFailure;
}
