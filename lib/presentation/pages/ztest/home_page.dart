import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../injection.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ini Home Page'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                getIt<AuthBloc>().add(
                  const AuthEvent.signedOutRequested(),
                );
              },
              child: const Text('LogOut'),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/admin-list-user');
              },
              child: const Text('Admin List User'),
            ),
          ],
        ),
      ),
    );
  }
}
