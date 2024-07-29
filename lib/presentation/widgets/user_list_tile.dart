import 'package:flutter/material.dart';

import '../../component/widget/avatar_image.dart';
import '../../core/constant/colors.dart';
import '../../core/constant/theme.dart';
import '../../core/utils/app_helper.dart';
import '../../domain/entities/user.dart';

class UserListTile extends StatelessWidget {
  final User user;
  final void Function()? onTap;
  final bool enabled;
  final bool isWithdrawBalance;
  final bool isListUser;
  final bool isStoreWaste;

  const UserListTile({
    super.key,
    required this.user,
    this.onTap,
    this.enabled = true,
    this.isWithdrawBalance = false,
    this.isListUser = false,
    this.isStoreWaste = false,
  });

  const UserListTile.withdrawBalance({
    super.key,
    required this.user,
    this.onTap,
    this.enabled = true,
    this.isWithdrawBalance = true,
    this.isListUser = false,
    this.isStoreWaste = false,
  });

  const UserListTile.listUser({
    super.key,
    required this.user,
    this.onTap,
    this.enabled = true,
    this.isWithdrawBalance = false,
    this.isListUser = true,
    this.isStoreWaste = false,
  });

  const UserListTile.storeWaste({
    super.key,
    required this.user,
    this.onTap,
    this.enabled = true,
    this.isWithdrawBalance = false,
    this.isListUser = false,
    this.isStoreWaste = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: AvatarImage(
        photoUrl: user.photoUrl,
        username: user.fullName,
        size: 40,
        fontSize: 10,
      ),
      title: Text(
        user.fullName!,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.ellipsis,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      subtitle: Text(
        user.phoneNumber,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w300,
          overflow: TextOverflow.ellipsis,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.rt,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                  overflow: TextOverflow.ellipsis,
                  color: MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
                ),
              ),
              Text(
                ' / ',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                  overflow: TextOverflow.ellipsis,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                user.rw,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                  overflow: TextOverflow.ellipsis,
                  color: MyTheme.isDarkMode ? CColors.dangerDark : CColors.dangerLight,
                ),
              ),
            ],
          ),
          Builder(
            builder: (context) {
              if (isWithdrawBalance == true) {
                return Text(
                  AppHelper.intToIDR(user.balance),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                    overflow: TextOverflow.ellipsis,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              } else if (isListUser == true) {
                return Text(
                  '${user.role} ${user.village}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                    overflow: TextOverflow.ellipsis,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              } else if (isStoreWaste == true) {
                return Text(
                  '${user.village}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                    overflow: TextOverflow.ellipsis,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
