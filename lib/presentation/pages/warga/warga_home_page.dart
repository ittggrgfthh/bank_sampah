import 'package:bank_sampah/core/routing/router.dart';
import 'package:bank_sampah/injection.dart';
import 'package:bank_sampah/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WargaHomePage extends StatelessWidget {
  const WargaHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final warga = getIt<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Warga'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_rounded, size: 32), onPressed: () {}),
          Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              onTap: () => context.go('${AppRouterName.wargaHomePath}/${AppRouterName.profilePath}'),
              child: Ink.image(
                width: 32,
                height: 32,
                image: CachedNetworkImageProvider(warga.photoUrl ??
                    'https://avatars.mds.yandex.net/i?id=1b0ce6ca8b11735031618d51e2a7e336f6d6f7b5-9291521-images-thumbs&n=13'),
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          runSpacing: 10,
          children: [
            _buildSaldo(context),
            Text(
              'Total Sampah Terkumpul (900 kg)',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            _buildTotalSampah(context),
            Text(
              'Riwayat',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaldo(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.wallet_rounded,
                color: Theme.of(context).colorScheme.background,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                'Saldo',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              )
            ],
          ),
          Text(
            'Rp. 1.221.000',
            style: TextStyle(
              color: Theme.of(context).colorScheme.background,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSampah(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 5,
                  children: [
                    Icon(
                      Icons.wallet_rounded,
                      color: Theme.of(context).colorScheme.background,
                      size: 20,
                    ),
                    Text(
                      'Organik',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Text(
                  '791 Kg',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 5,
                  children: [
                    Icon(
                      Icons.wallet_rounded,
                      color: Theme.of(context).colorScheme.background,
                      size: 20,
                    ),
                    Text(
                      'An-Organik',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Text(
                  '791 Kg',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
