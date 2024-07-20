import 'package:bank_sampah/core/constant/theme.dart';
import 'package:flutter/material.dart';

import '../core/constant/colors.dart';

class MyInputTheme {
  TextStyle _buildTextStyle(
    Color color, {
    double size = 16.0,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double borderWidth = 1.0}) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: color, width: borderWidth),
    );
  }

  InputDecorationTheme theme(BuildContext context) => InputDecorationTheme(
        contentPadding: const EdgeInsets.all(16),
        // isDense: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // constraints: const BoxConstraints(maxWidth: 150),
        enabledBorder: _buildBorder(MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight, borderWidth: 2),
        errorBorder: _buildBorder(MyTheme.isDarkMode ? CColors.dangerDark : CColors.dangerLight),
        focusedErrorBorder: _buildBorder(MyTheme.isDarkMode ? CColors.dangerDark : CColors.dangerLight),
        // border: _buildBorder(Theme.of(context).colorScheme.primary, borderWidth: 2),
        focusedBorder: _buildBorder(MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight, borderWidth: 2),
        disabledBorder: _buildBorder(CColors.shadow),

        //TextStyle
        suffixStyle: _buildTextStyle(MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight),
        counterStyle: _buildTextStyle(MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight, size: 12),
        floatingLabelStyle: _buildTextStyle(MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight),
        errorStyle: _buildTextStyle(MyTheme.isDarkMode ? CColors.dangerDark : CColors.dangerLight, size: 12),
        helperStyle: _buildTextStyle(MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight, size: 12),
        hintStyle: _buildTextStyle(
          MyTheme.isDarkMode ? CColors.primaryDark.withAlpha(100) : CColors.primaryLight.withAlpha(100),
          size: 16,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: _buildTextStyle(MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight),
        prefixStyle: _buildTextStyle(MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight),
        prefixIconColor: MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
      );
}
