import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WithdrawBalanceListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? trailing;
  final String? photoUrl;
  final void Function()? onTap;

  const WithdrawBalanceListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.photoUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: photoUrl == null || photoUrl == '' ? Colors.blueAccent : Colors.transparent,
        ),
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.transparent,
          backgroundImage: photoUrl != null ? CachedNetworkImageProvider(photoUrl!) : null,
          child: photoUrl == null || photoUrl == ''
              ? Text(
                  title[0].toUpperCase() + title[1].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              : Container(),
        ),
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
            'Saldo',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            '$trailing',
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
