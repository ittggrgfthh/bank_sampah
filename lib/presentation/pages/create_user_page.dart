import 'package:bank_sampah/component/field/password_field.dart';
import 'package:bank_sampah/component/field/phone_field.dart';
import 'package:flutter/material.dart';

import '../../component/field/name_field.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final phoneController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PhoneField(
                  controller: phoneController,
                ),
                const SizedBox(height: 16),
                NameField(
                  controller: fullNameController,
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: passwordController,
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Confirm Password',
                  textInputAction: TextInputAction.done,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0.4,
      title: Text(
        'Tambah User',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            size: 26,
            Icons.notifications,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {},
        ),
        const CircleAvatar(
          backgroundImage: AssetImage('assets/images/ksa-logo-gradient-blue.png'),
          radius: 16,
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
