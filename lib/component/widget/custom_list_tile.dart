import 'package:bank_sampah/component/widget/avatar_image.dart';
import 'package:bank_sampah/core/constant/colors.dart';
import 'package:bank_sampah/core/constant/theme.dart';
import 'package:bank_sampah/domain/entities/transaction_waste.dart';
import 'package:bank_sampah/domain/entities/user.dart';
import 'package:flutter/material.dart';

import '../../core/utils/app_helper.dart';

class CustomListTile extends StatelessWidget {
  final User user;
  final TransactionWaste? transaction;
  final void Function()? onTap;
  final bool? isWithdrawBalance;
  final bool? isListUser;
  final bool? isTransactionHistory;
  final bool? isStoreWaste;
  final bool enabled;

  const CustomListTile({
    super.key,
    required this.user,
    this.onTap,
    this.enabled = true,
    this.isWithdrawBalance,
    this.isListUser,
    this.isTransactionHistory,
    this.isStoreWaste,
    this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    if (transaction == null) {
      return listTileUser(context);
    } else if (transaction != null) {
      return listTileTransaction(context);
    }
    return Container();
  }

  Widget listTileUser(BuildContext context) => ListTile(
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
                    AppHelper.intToIDR(user.pointBalance.currentBalance),
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

  Widget listTileTransaction(BuildContext context) => ListTile(
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
        subtitle: Builder(builder: (context) {
          if (transaction!.storeWaste != null) {
            final waste = transaction!.storeWaste!.waste;
            return Row(
              children: [
                Visibility(
                  visible: waste.organic > 0,
                  child: Row(
                    children: [
                      Icon(
                        Icons.eco_rounded,
                        size: 20,
                        color: MyTheme.isDarkMode ? CColors.successDark : CColors.successLight,
                      ),
                      Text(
                        '${waste.organic}kg',
                        style: TextStyle(
                          color: MyTheme.isDarkMode ? CColors.successDark : CColors.successLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ),
                Visibility(
                  visible: waste.inorganic > 0,
                  child: Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_rounded,
                        size: 20,
                        color: MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
                      ),
                      Text(
                        '${waste.inorganic}kg',
                        style: TextStyle(
                          color: MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Builder(builder: (context) {
            if (isTransactionHistory == true && transaction!.withdrawnBalance != null) {
              return Row(
                children: [
                  Icon(
                    Icons.currency_exchange_rounded,
                    size: 20,
                    color: MyTheme.isDarkMode ? CColors.dangerDark : CColors.dangerLight,
                  ),
                  Text(
                    AppHelper.intToIDR(transaction!.withdrawnBalance!.withdrawn),
                    style: TextStyle(
                      color: MyTheme.isDarkMode ? CColors.dangerDark : CColors.dangerLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              );
            }
            return Text(
              'Tarik Saldo',
              style: TextStyle(
                color: MyTheme.isDarkMode ? CColors.dangerDark : CColors.dangerLight,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            );
          });
        }),
        trailing: Builder(builder: (context) {
          if (isTransactionHistory == true) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  AppHelper.timeAgoFromMillisecond(transaction!.createdAt),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Builder(builder: (context) {
                      if (transaction!.storeWaste != null) {
                        return Text(
                          AppHelper.intToIDR(transaction!.storeWaste!.earnedBalance),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                      return Container();
                    }),
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
                          ),
                  ],
                )
              ],
            );
          }
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [],
          );
        }),
      );
}
