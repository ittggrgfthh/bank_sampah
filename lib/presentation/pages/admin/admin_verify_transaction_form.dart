import 'dart:io';

import 'package:bank_sampah/component/button/rounded_button.dart';
import 'package:bank_sampah/component/field/number_field.dart';
import 'package:bank_sampah/component/widget/confirmation_dialog.dart';
import 'package:bank_sampah/core/constant/colors.dart';
import 'package:bank_sampah/core/constant/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../component/widget/avatar_image.dart';
import '../../../core/routing/router.dart';
import '../../../injection.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/warga_home/warga_home_bloc.dart';

class AdminVerifyTransactionForm extends StatefulWidget {
  const AdminVerifyTransactionForm({super.key});

  @override
  State<AdminVerifyTransactionForm> createState() => _AdminVerifyTransactionFormState();
}

class _AdminVerifyTransactionFormState extends State<AdminVerifyTransactionForm> {
  @override
  Widget build(BuildContext context) {
    final warga = getIt<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
    String imageUrl = '';
    const List<String> inorganic = ['Plastik', 'Kertas', 'Kaca', 'Kaleng', 'Botol', 'Lainnya'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setor Sampah'),
        actions: [
          Hero(
            tag: 'profile',
            child: AvatarImage(
              photoUrl: warga.photoUrl,
              username: warga.fullName,
              onTap: () => context.goNamed(AppRouterName.profileName),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: BlocProvider(
        create: (context) => getIt<WargaHomeBloc>()..add(WargaHomeEvent.initialized(warga.id.toString())),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _text('Organik'),
            _whitespace(),
            NumberField(
              hintText: 'Jumlah sampah organik',
              initialValue: '0',
              postfix: const [Text('Kg')],
              prefix: Icon(
                Icons.eco_rounded,
                size: 14,
                color: MyTheme.isDarkMode ? CColors.successDark : CColors.successLight,
              ),
              onChanged: (value) {},
            ),
            _line(),
            _text('An-Organik'),
            _whitespace(),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              mainAxisSpacing: 0,
              crossAxisSpacing: 10,
              physics: const NeverScrollableScrollPhysics(),
              children: List<Widget>.generate(
                inorganic.length,
                (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _text(inorganic[index], 14),
                    _whitespace(),
                    _inputInorganic(),
                  ],
                ),
              ),
            ),
            _whitespace(),
            imageUrl != ''
                ? Image.file(File(imageUrl.toString()), fit: BoxFit.contain)
                : Container(
                    height: 200,
                    color: const Color.fromARGB(255, 226, 226, 226),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image,
                        size: 100,
                      ),
                    ),
                  ),
            _whitespace(20),
            RoundedButton(
              name: 'Setujui',
              selected: true,
              color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
              textColor: MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
              onPressed: () => ConfirmationDialog.dialog(
                context: context,
                title: 'Konfirmasi',
                content: 'Apakah anda yakin ingin menyetujui transaksi ini?',
                onPressedYes: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _whitespace([double? height = 10]) => SizedBox(height: height);

  Widget _line([double? height = 0.5]) =>
      SizedBox(height: height, width: double.infinity, child: Container(color: CColors.shadow));

  Widget _text(String title, [double? fontSize = 16]) {
    return Text(
      title,
      style: TextStyle(
        color: MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _inputInorganic() {
    return NumberField(
      hintText: 'Jumlah sampah anorganik',
      prefix: Icon(
        Icons.shopping_bag_rounded,
        size: 14,
        color: MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
      ),
      postfix: const [Text('Kg')],
      initialValue: '0',
      onChanged: (value) {},
    );
  }
}
