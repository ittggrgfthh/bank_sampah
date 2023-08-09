import 'package:another_flushbar/flushbar_helper.dart';
import 'package:bank_sampah/component/button/rounded_primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/field/password_field.dart';
import '../../component/field/phone_field.dart';
import '../../core/failures/auth_failure_messages.dart';
import '../../injection.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/signin_form_bloc/signin_form_bloc.dart';

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
                timeout: () => AuthFailureMessages.timeout,
                orElse: () => AuthFailureMessages.unexpected,
              ),
              (_) {
                context.read<AuthBloc>().add(const AuthEvent.authCheckRequested());
                return null;
              },
            ),
          );

          if (errorMessage != null) {
            FlushbarHelper.createError(message: errorMessage).show(context);
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
            CachedNetworkImage(
              height: 125,
              width: 125,
              imageUrl:
                  'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
            ),
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
              textInputAction: TextInputAction.done,
              onChanged: (password) => context.read<SignInFormBloc>().add(SignInFormEvent.passwordChanged(password)),
              validator: (_) {
                return context.read<SignInFormBloc>().state.password.fold(
                      (failure) => failure.message,
                      (_) => null,
                    );
              },
            ),
            const SizedBox(height: 40),

            // Align(
            //   alignment: Alignment.centerRight,
            //   child: BButton(
            //     label: 'Lupa kata sandi?',
            //     variant: BButtonVariant.bare,
            //     dense: true,
            //     size: BWidgetSize.mini,
            //     onPressed: () => context.pushNamed('password-reset'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
