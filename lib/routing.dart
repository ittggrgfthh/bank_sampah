import 'dart:async';

import 'package:bank_sampah/component/widget/scaffold_with_navbar.dart';
import 'package:bank_sampah/presentation/pages/admin/admin_home_page.dart';
import 'package:bank_sampah/presentation/pages/staff/input_sampah.dart';
import 'package:bank_sampah/presentation/pages/staff/riwayat_transaksi.dart';
import 'package:bank_sampah/presentation/pages/staff/tarik_saldo.dart';
import 'package:bank_sampah/presentation/pages/staff/tarik_saldo_form.dart';
import 'package:bank_sampah/presentation/pages/warga/warga_home_page.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'injection.dart';
import 'presentation/bloc/auth_bloc/auth_bloc.dart';
import 'presentation/pages/admin/admin_list_user_page.dart';
import 'presentation/pages/ztest/home_page.dart';
import 'presentation/pages/login_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shellNav');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/',
      name: 'root',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/admin-list-user',
      name: 'admin-list-user',
      builder: (context, state) => const AdminListUserPage(),
    ),
    GoRoute(
      path: '/admin-home',
      name: 'admin-home',
      builder: (context, state) => const AdminHomePage(),
    ),
    GoRoute(
      path: '/warga-home',
      name: 'warga-home',
      builder: (context, state) => const WargaHomePage(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => ScaffoldWithNavbar(child: child),
      routes: [
        GoRoute(
          path: '/input-sampah',
          name: 'input-sampah',
          builder: (context, state) => const InputSampah(),
        ),
        GoRoute(
          path: '/riwayat-transaksi',
          name: 'riwayat-transaksi',
          builder: (context, state) => const RiwayatTransaksi(),
        ),
        GoRoute(
          path: '/tarik-saldo',
          name: 'tarik-saldo',
          builder: (context, state) => const TarikSaldo(),
          routes: [
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: 'tarik-saldo-form',
              name: 'tarik-saldo-form',
              builder: (context, state) => const TarikSaldoForm(),
            ),
          ],
        ),
      ],
    ),
  ],
  redirect: (_, state) async {
    final String? a = await getIt<AuthBloc>().state.when(
      authenticated: (user) async {
        if (state.matchedLocation == '/login') {
          switch (user.role) {
            case 'warga':
              return '/warga-home';
            case 'staff':
              return '/input-sampah';
            case 'admin':
              return '/admin-home';
            default:
              return '/';
          }
        }

        return null;
      },
      unauthenticated: (_) async {
        return "/login";
      },
      initial: () {
        return null;
      },
    );
    return a;
  },
  refreshListenable: _RefreshStream(getIt<AuthBloc>().stream),
  debugLogDiagnostics: true,
);

// Method form depecrated go_route 5.0.0.
class _RefreshStream extends ChangeNotifier {
  _RefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
