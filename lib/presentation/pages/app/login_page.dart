import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../component/button/rounded_primary_button.dart';
import '../../../component/field/password_field.dart';
import '../../../component/field/phone_field.dart';
import '../../../core/failures/auth_failure_messages.dart';
import '../../../injection.dart';
import '../../bloc/bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignInFormBloc>(),
      child: BlocConsumer<SignInFormBloc, SignInFormState>(
        listenWhen: (previous, current) => previous.authFailureOrSuccessOption != current.authFailureOrSuccessOption,
        listener: (context, state) {
          final errorMessage = state.authFailureOrSuccessOption.fold(
            () => null,
            (failureOrSuccess) => failureOrSuccess.fold(
              (failure) => failure.maybeWhen(
                invalidPhoneNumberOrPassword: () => AuthFailureMessages.invalidPhoneNumberOrPassword,
                invalidPassword: () => AuthFailureMessages.invalidPassword,
                timeout: () => AuthFailureMessages.timeout,
                orElse: () => AuthFailureMessages.unexpected,
              ),
              (_) {
                context.read<AuthBloc>().add(const AuthEvent.authCheckRequested());
                context.read<FilterUserBloc>().add(const FilterUserEvent.loaded());
                return null;
              },
            ),
          );

          if (errorMessage != null) {
            Flushbar(
              message: errorMessage,
              flushbarPosition: FlushbarPosition.TOP,
              duration: const Duration(seconds: 3),
              icon: Icon(
                Icons.warning,
                size: 28.0,
                color: Colors.red[300],
              ),
              leftBarIndicatorColor: Colors.red[300],
            ).show(context);
          }
        },
        buildWhen: (previous, current) => previous.errorMessagesShown != current.errorMessagesShown,
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              body: _LoginPageBody(state.errorMessagesShown),
              bottomSheet: BlocBuilder<SignInFormBloc, SignInFormState>(
                buildWhen: (previous, current) => previous.isSubmitting != current.isSubmitting,
                builder: (context, state) {
                  return Hero(
                    tag: 'button1',
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: RoundedPrimaryButton(
                        buttonName: 'Masuk',
                        isLoading: state.isSubmitting,
                        onPressed: () async {
                          context.read<SignInFormBloc>().add(const SignInFormEvent.signInButtonPressed());
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoginPageBody extends StatelessWidget {
  const _LoginPageBody(this.errorMessagesShown);

  final bool errorMessagesShown;

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: errorMessagesShown ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        reverse: true,
        child: Column(
          children: [
            Text(
              'Masuk',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            SvgPicture.asset('assets/images/logo-kabupaten.svg'),
            const SizedBox(height: 20),
            const Hero(
              tag: 'display-text',
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  'Welcome back!',
                  maxLines: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            PhoneField(
              onChanged: (email) => context.read<SignInFormBloc>().add(SignInFormEvent.phoneNumberChanged(email)),
              validator: (_) {
                return context.read<SignInFormBloc>().state.phoneNumber.fold(
                      (failure) => failure.message,
                      (_) => null,
                    );
              },
            ),
            const SizedBox(height: 16),
            PasswordField(
              hintText: 'Kata sandi',
              helperText: 'Minimal 8 karakter.',
              textInputAction: TextInputAction.done,
              onChanged: (password) => context.read<SignInFormBloc>().add(SignInFormEvent.passwordChanged(password)),
              validator: (_) {
                return context.read<SignInFormBloc>().state.password.fold(
                      (failure) => failure.message,
                      (_) => null,
                    );
              },
              onFieldSubmitted: (value) {
                context.read<SignInFormBloc>().add(const SignInFormEvent.signInButtonPressed());
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
