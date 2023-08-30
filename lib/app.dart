import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'component/my_input_theme.dart';
import 'core/constant/theme.dart';
import 'core/routing/router.dart';
import 'injection.dart';
import 'presentation/bloc/auth_bloc/auth_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => getIt<AuthBloc>()..add(const AuthEvent.authCheckRequested()),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: MyTheme.lightMode.copyWith(inputDecorationTheme: MyInputTheme().theme(context)),
        darkTheme: MyTheme.darkMode.copyWith(inputDecorationTheme: MyInputTheme().theme(context)),
        routerConfig: router,
      ),
    );
  }
}
