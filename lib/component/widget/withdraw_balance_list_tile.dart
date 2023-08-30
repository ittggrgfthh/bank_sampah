import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'avatar_image.dart';

class WithdrawBalanceListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<String?>? trailing;
  final String? photoUrl;
  final void Function()? onTap;
  final bool enabled;

  const WithdrawBalanceListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.photoUrl,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: enabled,
      leading: AvatarImage(
        photoUrl: photoUrl,
        username: title,
        size: 40,
        fontSize: 12,
      ),
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Text('$subtitle'),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '${trailing![0]}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            '${trailing![1]}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
