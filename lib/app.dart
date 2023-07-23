import 'package:flutter/material.dart';

import 'core/constant/theme.dart';
import 'core/gen/fonts.gen.dart';
import 'routing.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Bank Sampah',
      theme: MyTheme.lightMode,
      darkTheme: MyTheme.darkMode,
      routerConfig: router,
    );
  }
}
