import 'package:bank_sampah/component/button/rounded_no_color_button.dart';
import 'package:bank_sampah/component/button/rounded_primary_button.dart';
import 'package:bank_sampah/component/button/rounded_success_button.dart';
import 'package:bank_sampah/component/button/rounded_warning_button.dart';
import 'package:bank_sampah/component/field/checkbox_field.dart';
import 'package:bank_sampah/component/field/chip_field.dart';
import 'package:bank_sampah/component/field/password_field.dart';
import 'package:bank_sampah/component/field/phone_field.dart';
import 'package:bank_sampah/component/string_extension.dart';
import 'package:flutter/material.dart';

class InputForm extends StatefulWidget {
  const InputForm({super.key});

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int? _selectedChoice = 0;
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
              Wrap(
                spacing: 30,
                children: List<Widget>.generate(
                  3,
                  (index) => ChipField(
                    labelName: labelName[index],
                    selected: _selectedChoice == index,
                    onSelected: (b) =>
                        setState(() => _selectedChoice = b ? index : null),
                  ),
                ),
              ),
              RoundedNoColorButton(
                buttonName: "Masuk",
                buttonTask: () {
                  if (_formKey.currentState!.validate()) {
                    String phoneNumber = _phoneController.text;
                    String password = _passwordController.text;
                    print('Phone Number: $phoneNumber');
                    print('Password: $password');
                    print('Selected: $_selectedChoice');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
