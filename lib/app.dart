import 'package:bank_sampah/component/my_input_theme.dart';
import 'package:flutter/material.dart';

import 'core/constant/theme.dart';
import 'routing.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Bank Sampah',
      theme: MyTheme.lightMode
          .copyWith(inputDecorationTheme: MyInputTheme().theme(context)),
      darkTheme: MyTheme.darkMode
          .copyWith(inputDecorationTheme: MyInputTheme().theme(context)),
      routerConfig: router,
    );
  }
}
