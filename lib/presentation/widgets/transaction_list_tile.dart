import 'package:flutter/material.dart';

import '../../component/widget/avatar_image.dart';
import '../../core/constant/colors.dart';
import '../../core/constant/theme.dart';
import '../../core/utils/app_helper.dart';
import '../../domain/entities/transaction.dart';

class TransactionListTile extends StatelessWidget {
  final Transaction? transaction;
  final void Function()? onTap;
  final bool enabled;
  final bool isTransactionHistory;

  const TransactionListTile({
    super.key,
    this.transaction,
    this.onTap,
    this.isTransactionHistory = false,
    required this.enabled,
  });

  const TransactionListTile.transactionHistory({
    super.key,
    this.transaction,
    this.onTap,
    this.isTransactionHistory = true,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final warga = transaction!.warga;
    return ListTile(
      enabled: enabled,
      onTap: onTap,
      leading: AvatarImage(
        photoUrl: warga.photoUrl,
        username: warga.fullName,
        size: 40,
        fontSize: 10,
      ),
      title: Text(
        warga.fullName!,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.ellipsis,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      subtitle: Builder(builder: (context) {
        if (transaction!.totalPrice != 0) {
          return Row(
            children: [
              Visibility(
                visible: transaction!.totalOrganicWeight > 0,
                child: Row(
                  children: [
                    Icon(
                      Icons.eco_rounded,
                      size: 20,
                      color: MyTheme.isDarkMode ? CColors.successDark : CColors.successLight,
                    ),
                    Text(
                      '${transaction!.totalOrganicWeight}kg',
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
                visible: transaction!.totalInorganicWeight > 0,
                child: Row(
                  children: [
                    Icon(
                      Icons.shopping_bag_rounded,
                      size: 20,
                      color: MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
                    ),
                    Text(
                      '${transaction!.totalInorganicWeight}kg',
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
          if (isTransactionHistory == true && transaction!.totalPrice != 0) {
            return Row(
              children: [
                Icon(
                  Icons.currency_exchange_rounded,
                  size: 20,
                  color: MyTheme.isDarkMode ? CColors.dangerDark : CColors.dangerLight,
                ),
                Text(
                  AppHelper.intToIDR(transaction!.totalPrice),
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
                    if (transaction!.totalPrice != 0) {
                      return Text(
                        AppHelper.intToIDR(transaction!.totalPrice),
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
}
