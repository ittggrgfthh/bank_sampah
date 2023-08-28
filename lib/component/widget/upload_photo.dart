import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/constant/colors.dart';
import '../../core/constant/theme.dart';

class UploadPhoto extends StatelessWidget {
  final void Function()? onTap;
  final Option<File> file;

  const UploadPhoto({
    super.key,
    required this.onTap,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) - 35,
        height: 152,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
          ),
        ),
        child: Center(
          child: file.fold(
            () => SvgPicture.asset(
              'assets/images/no-image.svg',
              colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
              height: 100,
            ),
            (file) => ClipOval(
              child: Image.file(
                file,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
