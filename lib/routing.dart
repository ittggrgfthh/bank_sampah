import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'component/widget/navbar_admin.dart';
import 'component/widget/navbar_staff.dart';
import 'domain/entities/user.dart';
import 'injection.dart';
import 'presentation/bloc/auth_bloc/auth_bloc.dart';
import 'presentation/pages/admin/admin_home_page.dart';
import 'presentation/pages/admin/admin_list_user_page.dart';
import 'presentation/pages/admin/edit_waste_price.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/staff/transaction_history.dart';
import 'presentation/pages/staff/store_waste_form.dart';
import 'presentation/pages/staff/store_waste_list.dart';
import 'presentation/pages/staff/tarik_saldo.dart';
import 'presentation/pages/staff/tarik_saldo_form.dart';
import 'presentation/pages/warga/warga_home_page.dart';
import 'presentation/pages/ztest/home_page.dart';

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
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => NavbarAdmin(child: child),
      routes: [
        GoRoute(
          path: '/admin-home',
          name: 'admin-home',
          builder: (context, state) => const AdminHomePage(),
        ),
        GoRoute(
          path: '/admin-list-user',
          name: 'admin-list-user',
          builder: (context, state) => const AdminListUserPage(),
        ),
        GoRoute(
          path: '/edit-price',
          name: 'edit-price',
          builder: (context, state) => const EditWastePrice(),
          routes: [
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: 'log-edit-price',
              name: 'log-edit-price',
              builder: (context, state) => StoreWasteFormPage(user: state.extra as User),
            ),
          ],
        ),
      ],
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => NavbarStaff(child: child),
      routes: [
        GoRoute(
          path: '/input-waste',
          name: 'input-waste',
          builder: (context, state) => const StoreWasteListPage(),
          routes: [
            GoRoute(
              path: 'input-waste-form',
              name: 'input-waste-form',
              builder: (context, state) => StoreWasteFormPage(user: state.extra as User),
            ),
          ],
        ),
        GoRoute(
          path: '/transaction-history',
          name: 'transaction-history',
          builder: (context, state) => const TransactionHistoryPage(),
        ),
        GoRoute(
          path: '/withdraw-balance',
          name: 'withdraw-balance',
          builder: (context, state) => const TarikSaldo(),
          routes: [
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: 'withdraw-balance-form',
              name: 'withdraw-balance-form',
              builder: (context, state) => TarikSaldoForm(user: state.extra as User),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/warga-home',
      name: 'warga-home',
      builder: (context, state) => const WargaHomePage(),
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
              return '/input-waste';
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
