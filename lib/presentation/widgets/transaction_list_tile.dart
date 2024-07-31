import 'package:flutter/material.dart';

import '../../component/widget/avatar_image.dart';
import '../../core/constant/colors.dart';
import '../../core/constant/theme.dart';
import '../../core/utils/app_helper.dart';
import '../../domain/entities/transaction.dart';

class TransactionListTile extends StatelessWidget {
  final Transaction transaction;
  final void Function()? onTap;
  final bool enabled;

  const TransactionListTile({
    super.key,
    required this.transaction,
    this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final warga = transaction.warga;
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
        return Row(
          children: [
            Visibility(
              visible: transaction.totalOrganicWeight > 0,
              child: Row(
                children: [
                  Icon(
                    Icons.eco_rounded,
                    size: 20,
                    color: MyTheme.isDarkMode ? CColors.successDark : CColors.successLight,
                  ),
                  Text(
                    '${transaction.totalOrganicWeight}kg',
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
              visible: transaction.totalInorganicWeight > 0,
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_bag_rounded,
                    size: 20,
                    color: MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
                  ),
                  Text(
                    '${transaction.totalInorganicWeight}kg',
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
      }),
      trailing: Builder(builder: (context) {
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [],
        );
      }),
    );
  }
}
