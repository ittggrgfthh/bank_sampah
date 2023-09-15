import 'package:bank_sampah/domain/entities/filter_user.dart';
import 'package:bank_sampah/domain/usecase/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/failures/failure.dart';
import '../../../domain/entities/user.dart';

part 'list_user_bloc.freezed.dart';
part 'list_user_event.dart';
part 'list_user_state.dart';

class ListUserBloc extends Bloc<ListUserEvent, ListUserState> {
  final GetFilteredUsers _getFilteredUsers;

  ListUserBloc(this._getFilteredUsers) : super(const ListUserState.initial()) {
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
    final filterUser = FilterUser(
      role: defaultRole == 'semua' ? null : defaultRole,
    );

    // final users = await _getAllUserByRole(defaultRole);
    final users = await _getFilteredUsers(filterUser);
    users.fold(
      (failure) => emit(ListUserState.loadFailure(failure)),
      (users) {
        if (filterUser.rws != null && filterUser.rws!.isNotEmpty) {
          users = users.where((user) => filterUser.rws!.contains(user.rw)).toList();
        }
        if (filterUser.rts != null && filterUser.rts!.isNotEmpty) {
          users = users.where((user) => filterUser.rts!.contains(user.rt)).toList();
        }
        emit(ListUserState.loadSuccess(users));
      },
    );
  }

  Future<void> _handleRoleChanged(Emitter<ListUserState> emit, String role) async {
    emit(const ListUserState.loadInProgress());
    // final users = await _getAllUserByRole(role);
    final users = await _getFilteredUsers(FilterUser(
      role: role == 'semua' ? null : role,
    ));
    users.fold(
      (failure) => emit(ListUserState.loadFailure(failure)),
      (users) => emit(ListUserState.loadSuccess(users)),
    );
  }

  Future<void> _handleUsersReceived(Emitter<ListUserState> emit, Either<Failure, List<User>> failureOrUsers) async {
    failureOrUsers.fold(
      (failure) => emit(ListUserState.loadFailure(failure)),
      (users) => emit(ListUserState.loadSuccess(users)),
    );
  }
}
