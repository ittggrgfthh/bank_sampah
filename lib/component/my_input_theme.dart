import 'package:flutter/material.dart';

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
        enabledBorder: _buildBorder(Theme.of(context).colorScheme.primary),
        errorBorder: _buildBorder(Theme.of(context).colorScheme.error),
        focusedErrorBorder: _buildBorder(Theme.of(context).colorScheme.primary),
        // border: _buildBorder(Theme.of(context).colorScheme.tertiary),
        focusedBorder: _buildBorder(Theme.of(context).colorScheme.primary),
        disabledBorder: _buildBorder(Theme.of(context).colorScheme.outline),

        //TextStyle
        suffixStyle: _buildTextStyle(Theme.of(context).primaryColor),
        counterStyle: _buildTextStyle(Theme.of(context).primaryColor, size: 12),
        floatingLabelStyle: _buildTextStyle(Theme.of(context).primaryColor),
        errorStyle: _buildTextStyle(Theme.of(context).colorScheme.error, size: 12),
        helperStyle: _buildTextStyle(Theme.of(context).primaryColor, size: 12),
        hintStyle: _buildTextStyle(
          Theme.of(context).colorScheme.primary.withAlpha(100),
          size: 16,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: _buildTextStyle(Theme.of(context).primaryColor),
        prefixStyle: _buildTextStyle(Theme.of(context).colorScheme.primary),
        prefixIconColor: Theme.of(context).colorScheme.primary,
      );
}
