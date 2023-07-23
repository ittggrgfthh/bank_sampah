import 'package:flutter/material.dart';

import '../../core/gen/assets.gen.dart';
import '../../core/constant/colors.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    fullNameController.addListener(() {
      setState(() {});
    });
    _focusNode
        .addListener(() => setState(() => _isFocused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: CColors.sky600,
        backgroundColor: CColors.background,
        elevation: 0.4,
        title: const Text(
          'Tambah User',
          style: TextStyle(
            color: CColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              size: 26,
              Icons.notifications,
              color: CColors.primary,
            ),
            onPressed: () {},
          ),
          CircleAvatar(
            backgroundImage: Assets.images.ksaLogoGradientBlue.provider(),
            radius: 16,
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Nama Lengkap',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CColors.primary,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  color: CColors.neutral0,
                  boxShadow: _isFocused
                      ? [
                          const BoxShadow(
                            color: CColors.primary,
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: TextFormField(
                  focusNode: _focusNode,
                  controller: fullNameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: CColors.primary,
                  ),
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(
                        color: CColors.negative,
                        width: 2,
                      ),
                    ),
                    suffixIcon: fullNameController.text.isEmpty
                        ? Container(width: 0)
                        : IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.amberAccent,
                            ),
                            onPressed: () => fullNameController.clear(),
                          ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(
                        color: CColors.primary,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(
                        width: 2,
                        color: CColors.primary,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  cursorColor: CColors.primary,
                  validator: (value) {
                    // if (_isFocused == true) {
                    //   return null;
                    // }
                    if (value!.isEmpty) {
                      return "text tidak boleh kosong";
                    }
                    if (value.length < 5) {
                      return "text tidak boleh kurang dari 5";
                    }

                    return null;
                  },
                  onFieldSubmitted: (value) {
                    if (_formKey.currentState!.validate()) {}
                  },
                  onTap: () => _formKey.currentState!.reset(),
                ),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     // Trigger form validation
              //     if (_formKey.currentState!.validate()) {
              //       // All the TextFormField inputs are valid
              //     }
              //   },
              //   child: Text('Submit'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
