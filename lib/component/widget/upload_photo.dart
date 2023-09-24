import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/constant/colors.dart';
import '../../core/constant/theme.dart';
import 'avatar_image.dart';

class UploadPhoto extends StatelessWidget {
  final void Function()? onTap;
  final Option<File> file;
  final String? photoUrl;

  const UploadPhoto({
    super.key,
    required this.onTap,
    required this.file,
    this.photoUrl,
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
            () => photoUrl == null
                ? SvgPicture.asset(
                    'assets/images/no-image.svg',
                    colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                    height: 100,
                  )
                : AvatarImage(photoUrl: photoUrl, size: 152),
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
