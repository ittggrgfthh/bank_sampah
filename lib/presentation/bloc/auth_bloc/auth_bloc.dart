import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constant/unauthenticated_reason.dart';
import '../../../core/failures/failure.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecase/get_signed_in_user.dart';
import '../../../domain/usecase/get_user_by_id.dart';
import '../../../domain/usecase/sign_out.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetSignedInUser getSignedInUser;
  final SignOut signOut;
  final GetUserById getUserById;

  AuthBloc({
    required this.getSignedInUser,
    required this.signOut,
    required this.getUserById,
  }) : super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      await event.when(
        authCheckRequested: () async {
          try {
            final result = await getSignedInUser();
            result.fold(
              () {
                emit(const AuthState.unauthenticated(
                  UnauthenticatedReason.notSignedIn,
                ));
              },
              (user) async {
                late final String oldUserId;

                state.maybeWhen(
                  authenticated: (oldUser) => oldUserId = oldUser.id,
                  orElse: () => oldUserId = '',
                );
                if (oldUserId != user.id && user.fullName == null) {
                  final userOrFailure = await getUserById(user.id);
                  userOrFailure.fold(
                    (_) {
                      emit(const AuthState.unauthenticated(UnauthenticatedReason.failedToLoadProfile));
                    },
                    (userProfile) {
                      final mergedUser = user.copyWith(
                        fullName: userProfile.fullName,
                        photoUrl: userProfile.photoUrl,
                      );
                      emit(AuthState.authenticated(mergedUser));
                    },
                  );
                } else {
                  emit(AuthState.authenticated(user));
                }
              },
            );
          } catch (e) {
            emit(const AuthState.unauthenticated(UnauthenticatedReason.failedToLoadProfile));
          }
        },
        signedOutRequested: () async {
          await signOut();
          emit(const AuthState.unauthenticated(UnauthenticatedReason.signedOut));
        },
        userProfileReceived: (failureOrUser) async {
          failureOrUser.fold(
            (failure) {
              failure.maybeWhen(
                unexpected: (_, __, ___) => emit(const AuthState.unauthenticated(
                  UnauthenticatedReason.failedToLoadProfile,
                )),
                orElse: () {},
              );
            },
            (user) => emit(AuthState.authenticated(user)),
          );
        },
      );
    });
  }
}
