import 'package:flutter/material.dart';

class TarikSaldoListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? trailing;
  final String? image;
  final void Function()? onTap;

  const TarikSaldoListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage(image ?? ''),
        child: image == null ? const Text('AR') : Container(),
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
