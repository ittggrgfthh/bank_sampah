import 'package:flutter/material.dart';

class RiwayatTransaksiListTile extends StatelessWidget {
  final String title;
  final List<String>? subtitle;
  final List<String>? trailing;
  final String? image;
  final void Function()? onTap;

  const RiwayatTransaksiListTile({
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
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blueAccent),
        child: const CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Text('AR'),
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
      subtitle: Row(
        children: [
          subtitle![0] == '0' ? Container() : const Icon(Icons.energy_savings_leaf),
          Text(subtitle![0] == '0' ? '' : subtitle![0]),
          const SizedBox(width: 5),
          subtitle![1] == '0' ? Container() : const Icon(Icons.wallet),
          Text(subtitle![1] == '0' ? '' : subtitle![1]),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            trailing![0],
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            trailing![1],
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
