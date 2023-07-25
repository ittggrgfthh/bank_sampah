import 'package:bank_sampah/component/button/rounded_no_color_button.dart';
import 'package:bank_sampah/component/button/rounded_primary_button.dart';
import 'package:bank_sampah/component/button/rounded_success_button.dart';
import 'package:bank_sampah/component/button/rounded_warning_button.dart';
import 'package:bank_sampah/component/field/password_field.dart';
import 'package:bank_sampah/component/field/phone_field.dart';
import 'package:flutter/material.dart';

class InputForm extends StatefulWidget {
  const InputForm({super.key});

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: const Column(
            children: [
              PhoneField(),
              PasswordField(),
              RoundedNoColorButton(task: "Elevated Button!"),
            ],
          ),
        ),
      ),
    );
  }
}
