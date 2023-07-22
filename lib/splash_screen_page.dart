import 'package:flutter/material.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.fill,
                scale: 0.5,
              ),
            ),
            const Text(
              'Bank Sampah',
              style: TextStyle(
                color: Color.fromRGBO(3, 105, 161, 1),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
