import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminHome'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: const Text('AdminHome Page'),
      ),
    );
  }
}
