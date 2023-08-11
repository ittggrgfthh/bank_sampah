import 'package:bank_sampah/component/button/rounded_danger_button.dart';
import 'package:bank_sampah/injection.dart';
import 'package:bank_sampah/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left_rounded),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: RoundedDangerButton(
            buttonName: 'Keluar',
            buttonTask: () => getIt<AuthBloc>().add(const AuthEvent.signedOutRequested()),
          ),
        ),
      ),
    );
  }
}
