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

  @override
  void initState() {
    super.initState();
    phoneController.addListener(() {
      setState(() {});
    });
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
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: CColors.primary,
              ),
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
            ),
          ],
        ),
      ),
    );
  }
}
