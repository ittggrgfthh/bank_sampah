import 'package:flutter/material.dart';

class ConfirmationDialog {
  static Future<bool?> dialog({
    required BuildContext context,
    required String title,
    required String content,
    required void Function()? onPressedYes,
    required void Function()? onPressedNo,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: onPressedYes,
            child: const Text('Ya'),
          ),
          TextButton(
            onPressed: onPressedNo,
            child: const Text('Tidak'),
          ),
        ],
      ),
    );
  }
}
