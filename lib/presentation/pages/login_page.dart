import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneController = TextEditingController();
  String password = '';
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    phoneController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            buildHeader(),
            buildPhone(),
            const SizedBox(height: 5),
            buildPassword(),
            const SizedBox(height: 34),
            ElevatedButton(
              onPressed: () {
                print('Email:  ${phoneController.text}');
                print('Password:  $password');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(3, 105, 161, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Masuk',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPhone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Telepon',
          style: TextStyle(
            color: Color.fromRGBO(3, 105, 161, 1),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 48,
          child: TextField(
            textAlignVertical: TextAlignVertical.top,
            controller: phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              suffixIcon: phoneController.text.isEmpty
                  ? Container(width: 0)
                  : IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.amberAccent,
                      ),
                      onPressed: () => phoneController.clear(),
                    ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(3, 105, 161, 1),
                  width: 2.0,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(
                  width: 3,
                  color: Colors.amberAccent,
                ),
              ),
            ),
            cursorColor: Colors.amberAccent,
          ),
        ),
      ],
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
          Image.asset(
            'assets/login-icon.png',
            width: 180,
          ),
        ],
      ),
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            color: Color.fromRGBO(3, 105, 161, 1),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 48,
          child: TextField(
            onSubmitted: (value) => setState(() => password = value),
            obscureText: !isPasswordVisible,
            textAlignVertical: TextAlignVertical.top,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: isPasswordVisible
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
                onPressed: () =>
                    setState(() => isPasswordVisible = !isPasswordVisible),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(3, 105, 161, 1),
                  width: 2.0,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(
                  width: 3,
                  color: Colors.amberAccent,
                ),
              ),
            ),
            cursorColor: Colors.amberAccent,
          ),
        ),
      ],
    );
  }
}
