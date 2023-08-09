import 'package:bank_sampah/core/constant/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TransactionHitoryListTile extends StatelessWidget {
  final String title;
  final List<String>? subtitle;
  final List<String>? trailing;
  final String? photoUrl;
  final void Function()? onTap;

  const TransactionHitoryListTile({
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
      subtitle: Row(
        children: [
          subtitle![0] == '0' ? Container() : const Icon(Icons.energy_savings_leaf, size: 20),
          const SizedBox(width: 4),
          Text(
            subtitle![0] == '0' ? '' : subtitle![0],
            style: const TextStyle(
              color: CColors.green500,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 10),
          subtitle![1] == '0' ? Container() : const Icon(Icons.wallet, size: 20),
          const SizedBox(width: 4),
          Text(
            subtitle![1] == '0' ? '' : subtitle![1],
            style: const TextStyle(
              color: CColors.red400,
              fontWeight: FontWeight.w400,
            ),
          ),
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
