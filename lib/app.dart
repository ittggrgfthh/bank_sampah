import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'component/my_input_theme.dart';
import 'core/constant/theme.dart';
import 'core/routing/router.dart';
import 'injection.dart';
import 'presentation/bloc/auth_bloc/auth_bloc.dart';
import 'presentation/bloc/filter_transaction_waste/filter_transaction_waste_bloc.dart';
import 'presentation/bloc/filter_user/filter_user_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => getIt<AuthBloc>()..add(const AuthEvent.authCheckRequested()),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => getIt<FilterUserBloc>()..add(const FilterUserEvent.loaded()),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => getIt<FilterTransactionWasteBloc>()..add(const FilterTransactionWasteEvent.loaded()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: MyTheme.lightMode.copyWith(inputDecorationTheme: MyInputTheme().theme(context)),
        darkTheme: MyTheme.darkMode.copyWith(inputDecorationTheme: MyInputTheme().theme(context)),
        routerConfig: router,
      ),
    );
  }
}
