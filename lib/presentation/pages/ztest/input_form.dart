import 'package:flutter/material.dart';

import '../../../component/button/rounded_no_color_button.dart';
import '../../../component/field/password_field.dart';
import '../../../component/field/phone_field.dart';

class InputForm extends StatefulWidget {
  const InputForm({super.key});
  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List<String> labelName = ['Warga', 'Staff', 'Admin'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            children: [
              PhoneField(controller: _phoneController),
              PasswordField(controller: _passwordController),
              RoundedNoColorButton(
                buttonName: "Masuk",
                buttonTask: () {
                  if (_formKey.currentState!.validate()) {}
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
