import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/failures/failure.dart';
import '../../../domain/entities/filter_user.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecase/usecase.dart';

part 'list_user_bloc.freezed.dart';
part 'list_user_event.dart';
part 'list_user_state.dart';

class ListUserBloc extends Bloc<ListUserEvent, ListUserState> {
  final GetFilteredUsers _getFilteredUsers;

  ListUserBloc(this._getFilteredUsers) : super(const ListUserState.initial()) {
    on<ListUserEvent>((event, emit) async {
      await event.when(
        initialized: (filter) => _handleInitialized(emit, filter),
        filterChanged: (FilterUser filter) => _handleRoleChanged(emit, filter),
        usersReceived: (failureOrUsers) => _handleUsersReceived(emit, failureOrUsers),
      );
    });
  }

  Future<void> _handleInitialized(Emitter<ListUserState> emit, FilterUser filter) async {
    emit(const ListUserState.loadInProgress());
    final users = await _getFilteredUsers(filter);
    users.fold(
      (failure) => emit(ListUserState.loadFailure(failure)),
      (users) {
        if (filter.rws != null && filter.rws!.isNotEmpty) {
          users = users.where((user) => filter.rws!.contains(user.rw)).toList();
        }
        if (filter.rts != null && filter.rts!.isNotEmpty) {
          users = users.where((user) => filter.rts!.contains(user.rt)).toList();
        }
        emit(ListUserState.loadSuccess(users));
      },
    );
  }

  Future<void> _handleRoleChanged(Emitter<ListUserState> emit, FilterUser filter) async {
    emit(const ListUserState.loadInProgress());
    // final users = await _getAllUserByRole(role);
    final users = await _getFilteredUsers(filter);
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
