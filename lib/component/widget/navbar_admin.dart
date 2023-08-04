import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavbarAdmin extends StatelessWidget {
  final Widget child;

  const NavbarAdmin({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Laporan',
            icon: Icon(Icons.list),
            activeIcon: Icon(Icons.list_alt),
          ),
          BottomNavigationBarItem(
            label: 'Buat User',
            icon: Icon(Icons.list),
            activeIcon: Icon(Icons.list_alt),
          ),
          BottomNavigationBarItem(
            label: 'Edit Harga',
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
        context.goNamed('admin-home');
        break;
      case 1:
        context.goNamed('admin-list-user');
        break;
      case 2:
        context.goNamed('edit-harga');
        break;
    }
  }

  int _calculatedSelectedIndex(BuildContext context) {
    final String uri = GoRouterState.of(context).uri.toString();
    if (uri.startsWith('/admin-list-user')) {
      return 1;
    }
    if (uri.startsWith('/edit-harga')) {
      return 2;
    }
    return 0;
  }
}
