import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/constant/colors.dart';
import '../../core/constant/theme.dart';
import '../../core/routing/router.dart';
import '../../injection.dart';
import '../../presentation/bloc/auth_bloc/auth_bloc.dart';
import '../../presentation/bloc/filter_user/filter_user_bloc.dart';
import '../../presentation/bloc/list_user/list_user_bloc.dart';
import '../../presentation/bloc/transaction_history/transaction_history_bloc.dart';

class NavbarStaff extends StatelessWidget {
  final Widget child;

  const NavbarStaff({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final staff = context.read<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
    final filterUser = context.read<FilterUserBloc>().state.whenOrNull(loadSuccess: (filter) => filter)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ListUserBloc>()..add(ListUserEvent.initialized(filterUser)),
        ),
        BlocProvider(
          create: (context) => getIt<TransactionHistoryBloc>()..add(TransactionHistoryEvent.initialized(staff.id)),
        ),
      ],
      child: Scaffold(
        body: child,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).colorScheme.primary,
                  spreadRadius: 2,
                  blurRadius: 1,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.primaryDark,
            items: [
              BottomNavigationBarItem(
                label: 'Simpan Sampah',
                icon: SvgPicture.asset(
                  'assets/images/add-form.svg',
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                ),
                activeIcon: SvgPicture.asset(
                  'assets/images/add-form-active.svg',
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Riwayat Transaksi',
                icon: SvgPicture.asset(
                  'assets/images/transaction-history.svg',
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                ),
                activeIcon: SvgPicture.asset(
                  'assets/images/transaction-history-active.svg',
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Tarik Saldo',
                icon: SvgPicture.asset(
                  'assets/images/withdraw-balance.svg',
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                ),
                activeIcon: SvgPicture.asset(
                  'assets/images/withdraw-balance-active.svg',
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                ),
              ),
            ],
            onTap: (index) => _onTap(context, index),
            currentIndex: _calculatedSelectedIndex(context),
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed(AppRouterName.staffWasteTransactionName);
        break;
      case 1:
        context.goNamed(AppRouterName.staffHistoryTransactionName);
        break;
      case 2:
        context.goNamed(AppRouterName.staffBalanceTransactionName);
        break;
    }
  }

  int _calculatedSelectedIndex(BuildContext context) {
    final String uri = GoRouterState.of(context).uri.toString();
    if (uri.startsWith(AppRouterName.staffHistoryTransactionPath)) {
      return 1;
    }
    if (uri.startsWith(AppRouterName.staffBalanceTransactionPath)) {
      return 2;
    }
    return 0;
  }
}
