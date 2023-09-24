import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../component/button/rounded_danger_button.dart';
import '../../component/widget/avatar_image.dart';
import '../../component/widget/confirmation_dialog.dart';
import '../../core/constant/colors.dart';
import '../../core/constant/theme.dart';
import '../../injection.dart';
import '../bloc/auth_bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = getIt<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.chevron_left_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: CColors.shadow),
              shape: BoxShape.circle,
            ),
            child: Hero(
              tag: 'profile',
              child: AvatarImage(
                photoUrl: user.photoUrl,
                username: user.fullName,
                size: 100,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              user.fullName!,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Info',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _ProfileListTile(
            title: 'Telepon',
            subtitle: '+62 ${user.phoneNumber}',
            onTap: null,
          ),
          const SizedBox(height: 5),
          _ProfileListTile(
            title: 'Alamat',
            subtitle: 'RT/RW ${user.rt}/${user.rw}, Desa ${user.village}.',
            onTap: null,
          ),
          const SizedBox(height: 100),
          RoundedDangerButton(
            buttonName: 'Keluar',
            buttonTask: () => ConfirmationDialog.dialog(
              context: context,
              title: 'Apakah kamu yakin mau Logout?',
              content: null,
              onPressedYes: () => getIt<AuthBloc>().add(const AuthEvent.signedOutRequested()),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final void Function()? onTap;

  const _ProfileListTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CColors.shadow),
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}
