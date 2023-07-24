import 'package:flutter/material.dart';

class MyInputTheme {
  TextStyle _buildTextStyle(Color color, {double size = 16.0}) {
    return TextStyle(color: color, fontSize: size);
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(color: color, width: 1.0),
    );
  }

  InputDecorationTheme theme(BuildContext context) => InputDecorationTheme(
        contentPadding: const EdgeInsets.all(16),
        isDense: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // constraints: const BoxConstraints(maxWidth: 150),
        enabledBorder: _buildBorder(Theme.of(context).primaryColor),
        errorBorder: _buildBorder(Theme.of(context).colorScheme.error),
        focusedErrorBorder: _buildBorder(Theme.of(context).colorScheme.error),
        border: _buildBorder(Theme.of(context).colorScheme.tertiary),
        focusedBorder: _buildBorder(Theme.of(context).primaryColor),
        disabledBorder: _buildBorder(Theme.of(context).colorScheme.outline),

        //TextStyle
        suffixStyle: _buildTextStyle(Theme.of(context).primaryColor),
        counterStyle: _buildTextStyle(Theme.of(context).primaryColor, size: 12),
        floatingLabelStyle: _buildTextStyle(Theme.of(context).primaryColor),
        errorStyle: _buildTextStyle(Theme.of(context).colorScheme.error, size: 12),
        helperStyle: _buildTextStyle(Theme.of(context).primaryColor, size: 12),
        hintStyle: _buildTextStyle(Theme.of(context).colorScheme.background),
        labelStyle: _buildTextStyle(Theme.of(context).primaryColor),
        prefixStyle: _buildTextStyle(Theme.of(context).primaryColor),
      );
}
