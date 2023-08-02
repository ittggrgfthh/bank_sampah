part of 'list_user_bloc.dart';

@freezed
class ListUserState with _$ListUserState {
  const factory ListUserState.initial() = _Initial;
  const factory ListUserState.loadInProgress() = _LoadInProgress;
  const factory ListUserState.loadSuccess(List<User> users) = _LoadSuccess;
  const factory ListUserState.loadFailure(Failure failure) = _LoadFailure;
}
