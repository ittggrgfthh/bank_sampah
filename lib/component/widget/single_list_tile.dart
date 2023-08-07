import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SingleListTile extends StatelessWidget {
  final String title;
  final String? image;
  final Widget? subtitle;
  final Widget? trailing;

  const SingleListTile({
    required this.title,
    this.image,
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
        leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: image == null || image == '' ? Colors.blueAccent : Colors.transparent,
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.transparent,
            backgroundImage: CachedNetworkImageProvider(image ?? ''),
            child: image == null || image == '' ? const Text('AR') : Container(),
          ),
        ),
        subtitle: subtitle,
        trailing: trailing,
      ),
    );
  }
}
