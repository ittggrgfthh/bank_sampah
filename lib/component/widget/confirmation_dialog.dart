import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmationDialog {
  static Future<bool?> dialog({
    required BuildContext context,
    required String title,
    required String? content,
    required void Function()? onPressedYes,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content == null || content == '' ? const SizedBox() : Text(content),
        actions: [
          TextButton(
            onPressed: onPressedYes,
            child: const Text('Ya'),
          ),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Tidak'),
          ),
        ],
      ),
    );
  }
}
