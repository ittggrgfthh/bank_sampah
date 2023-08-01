import 'package:flutter/material.dart';

class SingleListTile extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? subtitle;
  final Widget? trailing;

  const SingleListTile({
    required this.title,
    this.leading,
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
            offset: const Offset(4, 4),
            blurRadius: 4,
            spreadRadius: 1,
          )
        ],
      ),
      child: ListTile(
        title: Text(title),
        leading: leading,
        subtitle: subtitle,
        trailing: trailing,
      ),
    );
  }
}
