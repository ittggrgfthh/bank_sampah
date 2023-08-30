import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'avatar_image.dart';

class SingleListTile extends StatelessWidget {
  final String title;
  final String? photoUrl;
  final Widget? subtitle;
  final Widget? trailing;

  const SingleListTile({
    required this.title,
    this.photoUrl,
    this.subtitle,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary,
            offset: const Offset(1, 1),
            blurRadius: 5,
            spreadRadius: 1,
          )
        ],
      ),
      child: ListTile(
        title: Text(title),
        leading: AvatarImage(
          photoUrl: photoUrl,
          username: title,
          size: 40,
          fontSize: 12,
        ),
        subtitle: subtitle,
        trailing: trailing,
      ),
    );
  }
}
