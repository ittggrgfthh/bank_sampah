import 'package:flutter/material.dart';

import '../../core/gen/assets.gen.dart';

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
            Text(
              'Nama Lengkap',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.primary,
              ),
              decoration: InputDecoration(
                suffixIcon: phoneController.text.isEmpty
                    ? Container(width: 0)
                    : IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () => phoneController.clear(),
                      ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
