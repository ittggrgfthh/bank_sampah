import 'package:bank_sampah/core/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class NavbarAdmin extends StatelessWidget {
  final Widget child;

  const NavbarAdmin({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: 'Laporan',
            icon: SvgPicture.asset('assets/images/add-form.svg'),
            activeIcon: SvgPicture.asset('assets/images/add-form-active.svg'),
          ),
          BottomNavigationBarItem(
            label: 'Buat User',
            icon: SvgPicture.asset('assets/images/add-user.svg'),
            activeIcon: SvgPicture.asset('assets/images/add-user-active.svg'),
          ),
          BottomNavigationBarItem(
            label: 'Edit Harga',
            icon: SvgPicture.asset('assets/images/edit-balance.svg'),
            activeIcon: SvgPicture.asset('assets/images/edit-balance-active.svg'),
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
        context.goNamed(AppRouterName.adminReportName);
        break;
      case 1:
        context.goNamed(AppRouterName.adminListUsersName);
        break;
      case 2:
        context.goNamed(AppRouterName.adminWastePriceName);
        break;
    }
  }

  int _calculatedSelectedIndex(BuildContext context) {
    final String uri = GoRouterState.of(context).uri.toString();
    if (uri.startsWith(AppRouterName.adminListUsersPath)) {
      return 1;
    }
    if (uri.startsWith(AppRouterName.adminWastePricePath)) {
      return 2;
    }
    return 0;
  }
}
