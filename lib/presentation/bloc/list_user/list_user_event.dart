part of 'list_user_bloc.dart';

@freezed
class ListUserEvent with _$ListUserEvent {
  const factory ListUserEvent.initialized(FilterUser filter) = _Initialized;
  const factory ListUserEvent.filterChanged(FilterUser filter) = _FilterChanged;
  const factory ListUserEvent.usersReceived(Either<Failure, List<User>> failureOrUsers) = _UsersRecived;
}
