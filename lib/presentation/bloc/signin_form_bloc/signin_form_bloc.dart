import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/failures/auth_failure.dart';
import '../../../core/failures/value_failure.dart';
import '../../../core/utils/value_validators.dart';
import '../../../domain/usecase/signin_with_phone_number_and_password.dart';

part 'signin_form_bloc.freezed.dart';
part 'signin_form_event.dart';
part 'signin_form_state.dart';

class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final SigninWithPhoneNumberAndPassword signinWithPhoneNumberAndPassword;

  SignInFormBloc(this.signinWithPhoneNumberAndPassword) : super(SignInFormState.initial()) {
    on<SignInFormEvent>((event, emit) async {
      await event.when(
        phoneNumberChanged: (phoneNumber) => _handlePhoneNumberChanged(emit, phoneNumber),
        passwordChanged: (password) => _handlePasswordChanged(emit, password),
        signInButtonPressed: () => _handleSignInButtonPressed(emit),
      );
    });
  }

  Future<void> _handlePhoneNumberChanged(Emitter<SignInFormState> emit, String phoneNumber) async {
    emit(state.copyWith(phoneNumber: validatePhoneNumber(phoneNumber, false)));
  }

  Future<void> _handlePasswordChanged(Emitter<SignInFormState> emit, String password) async {
    emit(state.copyWith(password: validatePassword(password, 8)));
  }

  Future<void> _handleSignInButtonPressed(Emitter<SignInFormState> emit) async {
    final isPhoneNumberValid = state.phoneNumber.isRight();
    final isPasswordValid = state.password.isRight();
    Either<AuthFailure, Unit>? failureOrSuccess;

    if (isPhoneNumberValid && isPasswordValid) {
      emit(state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      ));

      final phoneNumber = state.phoneNumber.getOrElse((_) => '');
      final password = state.password.getOrElse((_) => '');

      failureOrSuccess = await signinWithPhoneNumberAndPassword(
        phoneNumber: phoneNumber,
        password: password,
      );
    }

    emit(state.copyWith(
      isSubmitting: false,
      errorMessagesShown: true,
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    ));
  }
}
