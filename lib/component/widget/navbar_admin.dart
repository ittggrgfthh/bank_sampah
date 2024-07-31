import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/constant/colors.dart';
import '../../core/constant/theme.dart';
import '../../core/routing/router.dart';
import '../../injection.dart';
import '../../presentation/bloc/filter_user/filter_user_bloc.dart';
import '../../presentation/bloc/list_user/list_user_bloc.dart';

class NavbarAdmin extends StatelessWidget {
  final Widget child;

  const NavbarAdmin({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final filterUser = context.read<FilterUserBloc>().state.whenOrNull(loadSuccess: (filter) => filter)!;
    return BlocProvider(
      create: (context) => getIt<ListUserBloc>()..add(ListUserEvent.initialized(filterUser)),
      child: Scaffold(
        body: child,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                  color: MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
                  spreadRadius: 2,
                  blurRadius: 1,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: BottomNavigationBar(
            selectedItemColor: MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
            items: [
              BottomNavigationBarItem(
                backgroundColor: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
                label: 'Laporan',
                icon: SvgPicture.asset(
                  'assets/images/add-form.svg',
                  colorFilter: ColorFilter.mode(
                    MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  'assets/images/add-form-active.svg',
                  colorFilter: ColorFilter.mode(
                    MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                backgroundColor: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
                label: 'Pengguna',
                icon: SvgPicture.asset(
                  'assets/images/add-user.svg',
                  colorFilter: ColorFilter.mode(
                    MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  'assets/images/add-user-active.svg',
                  colorFilter: ColorFilter.mode(
                    MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                backgroundColor: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
                label: 'Edit Harga',
                icon: SvgPicture.asset(
                  'assets/images/edit-balance.svg',
                  colorFilter: ColorFilter.mode(
                    MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  'assets/images/edit-balance-active.svg',
                  colorFilter: ColorFilter.mode(
                    MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                backgroundColor: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
                label: 'Transaksi',
                icon: SvgPicture.asset(
                  'assets/images/edit-balance.svg',
                  colorFilter: ColorFilter.mode(
                    MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  'assets/images/edit-balance-active.svg',
                  colorFilter: ColorFilter.mode(
                    MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
                    BlendMode.srcIn,
                  ),
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
        context.goNamed(AppRouterName.adminReportName);
        break;
      case 1:
        context.goNamed(AppRouterName.adminListUsersName);
        break;
      case 2:
        context.goNamed(AppRouterName.adminWastePriceName);
        break;
      case 3:
        context.goNamed(AppRouterName.adminListTransactionName);
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
    if (uri.startsWith(AppRouterName.adminListTransactionPath)) {
      return 3;
    }
    return 0;
  }
}
