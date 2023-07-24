import 'package:bank_sampah/data/models/user_model.dart';
import 'package:flutter/material.dart';

import '../../core/gen/assets.gen.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../injection.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final userDataSource = getIt<UserRemoteDataSource>();

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
          children: <Widget>[],
        ),
      ),
    );
  }
}
