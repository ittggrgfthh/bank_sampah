part of 'list_user_bloc.dart';

@freezed
class ListUserEvent with _$ListUserEvent {
  const factory ListUserEvent.initialized() = _Initialized;
  const factory ListUserEvent.roleChanged(String role) = _RoleChanged;
  const factory ListUserEvent.usersReceived(Either<Failure, List<User>> failureOrUsers) = _UsersRecived;
}
