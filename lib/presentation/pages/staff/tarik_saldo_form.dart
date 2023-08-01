import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TarikSaldoForm extends StatelessWidget {
  const TarikSaldoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarik Saldo'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left_rounded),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeader(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.amber,
    );
  }
}
