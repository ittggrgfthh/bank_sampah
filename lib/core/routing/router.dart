import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../component/widget/navbar_admin.dart';
import '../../component/widget/navbar_staff.dart';
import '../../domain/entities/transaction_waste.dart';
import '../../injection.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/pages/pages.dart';

part "path_name_router.dart";

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shellNav');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: AppRouterName.rootPath,
      name: AppRouterName.rootName,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRouterName.loginPath,
      name: AppRouterName.loginName,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRouterName.profilePath,
      name: AppRouterName.profileName,
      builder: (context, state) => const ProfilePage(),
    ),

    /// Admin
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => NavbarAdmin(child: child),
      routes: [
        GoRoute(
          path: AppRouterName.adminReportPath,
          name: AppRouterName.adminReportName,
          pageBuilder: (context, state) => const NoTransitionPage(child: AdminReportPage()),
        ),
        GoRoute(
          path: AppRouterName.adminListUsersPath,
          name: AppRouterName.adminListUsersName,
          pageBuilder: (context, state) => const NoTransitionPage(child: AdminUserListPage()),
          routes: [
            GoRoute(
              path: AppRouterName.adminCreateUserPath,
              name: AppRouterName.adminCreateUserName,
              builder: (context, state) => const AdminUserCreateForm(),
            ),
            GoRoute(
              path: AppRouterName.adminEditUserPath,
              name: AppRouterName.adminEditUserName,
              builder: (context, state) => AdminUserUpdateForm(userId: state.pathParameters['userId'] ?? ''),
            ),
          ],
        ),
        GoRoute(
          path: AppRouterName.adminWastePricePath,
          name: AppRouterName.adminWastePriceName,
          pageBuilder: (context, state) => const NoTransitionPage(child: AdminEditWastePriceForm()),
          routes: [
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: AppRouterName.adminWastePriceLogPath,
              name: AppRouterName.adminWastePriceLogName,
              builder: (context, state) => const AdminEditWastePriceHistoryPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRouterName.wargaHomePath,
      name: AppRouterName.wargaHomeName,
      builder: (context, state) => const WargaHomePage(),
    ),
  ],
  redirect: (_, state) async {
    final String? path = await getIt<AuthBloc>().state.when(
      authenticated: (user) async {
        if (state.matchedLocation == AppRouterName.loginPath || state.matchedLocation == AppRouterName.rootPath) {
          switch (user.role) {
            case 'WARGA':
              return AppRouterName.wargaHomePath;
            case 'STAFF':
              return AppRouterName.staffWasteTransactionPath;
            case 'ADMIN':
              return AppRouterName.adminReportPath;
            default:
              return AppRouterName.loginPath;
          }
        }

        return null;
      },
      unauthenticated: (_) async {
        return AppRouterName.loginPath;
      },
      initial: () {
        return null;
      },
    );
    return path;
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
