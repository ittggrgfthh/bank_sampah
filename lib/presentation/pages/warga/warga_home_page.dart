import 'package:flutter/material.dart';

class WargaHomePage extends StatelessWidget {
  const WargaHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Warga')),
      body: const Center(child: Text('Home Warga')),
    );
  }
}
