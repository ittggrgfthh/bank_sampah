import 'package:flutter/material.dart';

import '../../injection.dart';
import '../bloc/auth_bloc/auth_bloc.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('coba'),
            ElevatedButton(
              onPressed: () {
                getIt<AuthBloc>().state.when(initial: () {}, authenticated: (user) {}, unauthenticated: (reason) {});
                getIt<AuthBloc>().add(
                  const AuthEvent.signedOutRequested(),
                );
                getIt<AuthBloc>().state.when(initial: () {}, authenticated: (user) {}, unauthenticated: (reason) {});
              },
              child: const Text('LogOut'),
            ),
          ],
        ),
      ),
    );
  }
}
