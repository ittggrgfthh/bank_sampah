import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavbarStaff extends StatelessWidget {
  final Widget child;

  const NavbarStaff({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed('input-waste');
        break;
      case 1:
        context.goNamed('transaction-history');
        break;
      case 2:
        context.goNamed('withdraw-balance');
        break;
    }
  }

  int _calculatedSelectedIndex(BuildContext context) {
    final String uri = GoRouterState.of(context).uri.toString();
    if (uri.startsWith('/riwayat-transaksi')) {
      return 1;
    }
    if (uri.startsWith('/tarik-saldo')) {
      return 2;
    }
    return 0;
  }
}
