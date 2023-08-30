import 'package:flutter/material.dart';

import '../../core/constant/colors.dart';
import '../../core/constant/theme.dart';
import 'avatar_image.dart';

class TransactionHitoryListTile extends StatelessWidget {
  final String title;
  final List<String>? subtitle;
  final List<String>? trailing;
  final String? photoUrl;
  final void Function()? onTap;
  final bool enabled;

  const TransactionHitoryListTile({
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
          overflow: TextOverflow.ellipsis,
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Row(
        children: [
          subtitle![0] == '0'
              ? const SizedBox()
              : RowSubtitle(
                  text: subtitle![0],
                  icon: Icons.eco_rounded,
                  color: MyTheme.isDarkMode ? CColors.successDark : CColors.successLight,
                ),
          subtitle![1] == '0'
              ? const SizedBox()
              : RowSubtitle(
                  text: subtitle![1],
                  icon: Icons.shopping_bag_rounded,
                  color: MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
                ),
          subtitle![2] == '0'
              ? const SizedBox()
              : RowSubtitle(
                  text: subtitle![2],
                  icon: Icons.currency_exchange_rounded,
                  color: MyTheme.isDarkMode ? CColors.dangerDark : CColors.dangerLight,
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              trailing![1] == '-'
                  ? const SizedBox()
                  : Text(
                      trailing![1],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
              const SizedBox(width: 5),
              enabled
                  ? Icon(
                      Icons.save_as_rounded,
                      size: 16,
                      color: MyTheme.isDarkMode ? CColors.successDark : CColors.successLight,
                    )
                  : Icon(
                      Icons.lock,
                      size: 16,
                      color: MyTheme.isDarkMode ? CColors.dangerDark : CColors.dangerLight,
                    )
            ],
          ),
        ],
      ),
    );
  }
}

class RowSubtitle extends StatelessWidget {
  const RowSubtitle({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
  });

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: color,
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }
}
