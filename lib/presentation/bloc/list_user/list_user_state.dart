part of 'list_user_bloc.dart';

@freezed
class ListUserState with _$ListUserState {
  const factory ListUserState({
    required String role,
  }) = _ListUserState;

  factory ListUserState.initial() => const _ListUserState(
        role: 'all',
      );

  const factory ListUserState.loadInProgress() = _LoadInProgress;
  const factory ListUserState.loadSuccess(List<User> users) = _LoadSuccess;
  const factory ListUserState.loadFailure(Failure failure) = _LoadFailure;
}
