import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constant/colors.dart';
import '../../core/constant/theme.dart';
import '../../presentation/bloc/create_user_form/create_user_form_bloc.dart';

class UploadPhoto extends StatelessWidget {
  final void Function()? onTap;
  const UploadPhoto({super.key, required this.onTap});

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
        child: BlocBuilder<CreateUserFormBloc, CreateUserFormState>(
          builder: (context, state) {
            return Center(
                child: state.profilePictureOption.fold(
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
            ));
          },
        ),
      ),
    );
  }
}
