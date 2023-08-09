import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../component/widget/navbar_admin.dart';
import '../../component/widget/navbar_staff.dart';
import '../../domain/entities/user.dart';
import '../../injection.dart';
import '../../presentation/bloc/auth_bloc/auth_bloc.dart';
import '../../presentation/pages/admin/admin_home_page.dart';
import '../../presentation/pages/admin/admin_list_user_page.dart';
import '../../presentation/pages/admin/edit_waste_price.dart';
import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/staff/transaction_history.dart';
import '../../presentation/pages/staff/store_waste_form.dart';
import '../../presentation/pages/staff/store_waste_list.dart';
import '../../presentation/pages/staff/tarik_saldo.dart';
import '../../presentation/pages/staff/tarik_saldo_form.dart';
import '../../presentation/pages/warga/warga_home_page.dart';
import '../../presentation/pages/ztest/home_page.dart';

part "path_name_router.dart";

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shellNav');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: AppRouterName.rootPath,
      name: AppRouterName.rootName,
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: AppRouterName.loginPath,
      name: AppRouterName.loginName,
      builder: (context, state) => const LoginPage(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => NavbarAdmin(child: child),
      routes: [
        GoRoute(
          path: AppRouterName.adminReportPath,
          name: AppRouterName.adminReportName,
          builder: (context, state) => const AdminHomePage(),
        ),
        GoRoute(
          path: AppRouterName.adminListUsersPath,
          name: AppRouterName.adminListUsersName,
          builder: (context, state) => const AdminListUserPage(),
        ),
        GoRoute(
          path: AppRouterName.adminWastePricePath,
          name: AppRouterName.adminWastePriceName,
          builder: (context, state) => const EditWastePrice(),
          routes: [
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: AppRouterName.adminWastePriceLogPath,
              name: AppRouterName.adminWastePriceLogName,
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
          path: AppRouterName.staffWasteTransactionPath,
          name: AppRouterName.staffWasteTransactionName,
          builder: (context, state) => const StoreWasteListPage(),
          routes: [
            GoRoute(
              path: AppRouterName.staffStoreWastePath,
              name: AppRouterName.staffStoreWasteName,
              builder: (context, state) => StoreWasteFormPage(user: state.extra as User),
            ),
          ],
        ),
        GoRoute(
          path: AppRouterName.staffHistoryTransactionPath,
          name: AppRouterName.staffHistoryTransactionName,
          builder: (context, state) => const TransactionHistoryPage(),
        ),
        GoRoute(
          path: AppRouterName.staffBalanceTransactionPath,
          name: AppRouterName.staffBalanceTransactionName,
          builder: (context, state) => const TarikSaldo(),
          routes: [
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: AppRouterName.staffWithdrawPath,
              name: AppRouterName.staffWithdrawName,
              builder: (context, state) => TarikSaldoForm(user: state.extra as User),
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
    final String? a = await getIt<AuthBloc>().state.when(
      authenticated: (user) async {
        if (state.matchedLocation == AppRouterName.loginPath) {
          switch (user.role) {
            case 'warga':
              return AppRouterName.wargaHomePath;
            case 'staff':
              return AppRouterName.staffWasteTransactionPath;
            case 'admin':
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
