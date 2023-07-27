import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'injection.dart';
import 'presentation/bloc/auth_bloc/auth_bloc.dart';
import 'presentation/pages/admin_list_user_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/login_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/',
      name: 'root',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/admin-list-user',
      name: 'admin-list-user',
      builder: (context, state) => const AdminListUserPage(),
    ),
  ],
  redirect: (_, state) async {
    final String? a = await getIt<AuthBloc>().state.when(
      authenticated: (user) async {
        if (state.matchedLocation == '/login') {
          return '/';
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
