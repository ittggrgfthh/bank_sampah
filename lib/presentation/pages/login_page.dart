import 'package:bank_sampah/component/button/rounded_primary_button.dart';
import 'package:bank_sampah/component/field/password_field.dart';
import 'package:bank_sampah/component/field/phone_field.dart';
import 'package:flutter/material.dart';

import '../../core/gen/assets.gen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: ListView(
            children: [
              buildHeader(),
              const SizedBox(height: 30),
              PhoneField(controller: phoneController),
              PasswordField(controller: passwordController),
              const SizedBox(height: 30),
              RoundedPrimaryButton(
                buttonName: 'Masuk',
                buttonTask: () {
                  if (_formKey.currentState!.validate()) {
                    String phoneNumber = phoneController.text;
                    String password = passwordController.text;
                    print('Phone Number: $phoneNumber');
                    print('Password: $password');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Center(
      child: Column(
        children: [
          const Text(
            'Masuk',
            style: TextStyle(
              color: Color.fromRGBO(3, 105, 161, 1),
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          Assets.images.loginIcon.image(width: 180),
        ],
      ),
    );
  }
}
