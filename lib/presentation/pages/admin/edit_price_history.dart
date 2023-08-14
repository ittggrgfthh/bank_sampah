import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/theme.dart';
import '../../../core/utils/currency_converter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../component/dummy/dummy_data.dart';
import '../../../component/widget/transaction_histry_list_tile.dart';
import '../../../core/utils/date_time_converter.dart';
import '../../../domain/entities/waste_price.dart';

class EditPriceHistory extends StatelessWidget {
  const EditPriceHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final List<WastePrice> logEditPrices = DummyData.dummyEditHarga;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Edit Harga'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left_rounded),
        ),
      ),
      body: ListView.builder(
        itemCount: logEditPrices.length,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          child: ListTile(
            title: Text(DateTimeConverter.millisecondEpochtoString(logEditPrices[index].createdAt)),
            subtitle: Row(
              children: [
                RowSubtitle(
                  text: CurrencyConverter.intToIDR(logEditPrices[index].organic),
                  icon: Icons.eco_rounded,
                  color: MyTheme.isDarkMode ? CColors.successDark : CColors.successLight,
                ),
                RowSubtitle(
                  text: CurrencyConverter.intToIDR(logEditPrices[index].inorganic),
                  icon: Icons.shopping_bag_rounded,
                  color: MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
                ),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: logEditPrices[index].admin.photoUrl == null || logEditPrices[index].admin.photoUrl == ''
                        ? Colors.blueAccent
                        : Colors.transparent,
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: logEditPrices[index].admin.photoUrl != null
                        ? CachedNetworkImageProvider(logEditPrices[index].admin.photoUrl!)
                        : null,
                    child: logEditPrices[index].admin.photoUrl == null || logEditPrices[index].admin.photoUrl == ''
                        ? Text(
                            logEditPrices[index].admin.fullName![0].toUpperCase() +
                                logEditPrices[index].admin.fullName![1].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          )
                        : Container(),
                  ),
                ),
                Text(
                  'Admin ${logEditPrices[index].admin.fullName}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
