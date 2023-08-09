import 'package:bank_sampah/core/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../injection.dart';
import '../../presentation/bloc/list_user/list_user_bloc.dart';

class NavbarStaff extends StatelessWidget {
  final Widget child;

  const NavbarStaff({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ListUserBloc>()..add(const ListUserEvent.initialized('warga')),
      child: Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              label: 'Simpan Sampah',
              icon: Icon(Icons.list),
              activeIcon: Icon(Icons.list_alt),
            ),
            BottomNavigationBarItem(
              label: 'Riwayat Transaksi',
              icon: Icon(Icons.list),
              activeIcon: Icon(Icons.list_alt),
            ),
            BottomNavigationBarItem(
              label: 'Tarik Saldo',
              icon: Icon(Icons.list),
              activeIcon: Icon(Icons.list_alt),
            ),
          ],
          onTap: (index) => _onTap(context, index),
          currentIndex: _calculatedSelectedIndex(context),
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
