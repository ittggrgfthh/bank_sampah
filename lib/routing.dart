import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'presentation/pages/create_user_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/login_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');
// final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shellNav');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const CreateUserPage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/profile-setup',
      name: 'profile-setup',
      builder: (context, state) => const MyHomePage(),
    ),
  ],
);
