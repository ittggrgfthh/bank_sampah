import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/failures/failure.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecase/admin/get_all_user_by_role.dart';

part 'list_user_bloc.freezed.dart';
part 'list_user_event.dart';
part 'list_user_state.dart';

class ListUserBloc extends Bloc<ListUserEvent, ListUserState> {
  final GetAllUserByRole _getAllUserByRole;

  ListUserBloc(this._getAllUserByRole) : super(const ListUserState.initial()) {
    on<ListUserEvent>((event, emit) async {
      await event.when(
        initialized: (defaultRole) => _handleInitialized(emit, defaultRole),
        roleChanged: (String role) => _handleRoleChanged(emit, role),
        usersReceived: (failureOrUsers) => _handleUsersReceived(emit, failureOrUsers),
      );
    });
  }

  Future<void> _handleInitialized(Emitter<ListUserState> emit, String defaultRole) async {
    emit(const ListUserState.loadInProgress());
    final users = await _getAllUserByRole(defaultRole);
    users.fold(
      (failure) => emit(ListUserState.loadFailure(failure)),
      (users) => emit(ListUserState.loadSuccess(users!)),
    );
  }

  Future<void> _handleRoleChanged(Emitter<ListUserState> emit, String role) async {
    emit(const ListUserState.loadInProgress());
    final users = await _getAllUserByRole(role);
    users.fold(
      (failure) => emit(ListUserState.loadFailure(failure)),
      (users) => emit(ListUserState.loadSuccess(users!)),
    );
  }

  Future<void> _handleUsersReceived(Emitter<ListUserState> emit, Either<Failure, List<User>> failureOrUsers) async {
    failureOrUsers.fold(
      (failure) => emit(ListUserState.loadFailure(failure)),
      (users) => emit(ListUserState.loadSuccess(users)),
    );
  }
}
