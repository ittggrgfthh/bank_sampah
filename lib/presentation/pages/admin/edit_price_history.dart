import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/widget/transaction_histry_list_tile.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/theme.dart';
import '../../../core/utils/app_helper.dart';
import '../../../core/utils/date_time_converter.dart';
import '../../../injection.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/edit_waste_price_history/edit_waste_price_history_bloc.dart';

class EditPriceHistory extends StatelessWidget {
  const EditPriceHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = context.read<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Edit Harga'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left_rounded),
        ),
      ),
      body: BlocProvider(
        create: (context) => getIt<EditWastePriceHistoryBloc>()..add(const EditWastePriceHistoryEvent.initialized()),
        child: BlocBuilder<EditWastePriceHistoryBloc, EditWastePriceHistoryState>(
          builder: (context, state) {
            return state.maybeWhen(
              loadSuccess: (editWastePriceHistory) {
                if (editWastePriceHistory.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada riwayat edit harga'),
                  );
                }
                return ListView.builder(
                  itemCount: editWastePriceHistory.length,
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    child: ListTile(
                      title: Text(DateTimeConverter.millisecondEpochtoString(editWastePriceHistory[index].createdAt)),
                      subtitle: Row(
                        children: [
                          RowSubtitle(
                            text: AppHelper.intToIDR(editWastePriceHistory[index].organic),
                            icon: Icons.eco_rounded,
                            color: MyTheme.isDarkMode ? CColors.successDark : CColors.successLight,
                          ),
                          RowSubtitle(
                            text: AppHelper.intToIDR(editWastePriceHistory[index].inorganic),
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
                              color: editWastePriceHistory[index].admin.photoUrl == null ||
                                      editWastePriceHistory[index].admin.photoUrl == ''
                                  ? Colors.blueAccent
                                  : Colors.transparent,
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: editWastePriceHistory[index].admin.photoUrl != null
                                  ? CachedNetworkImageProvider(editWastePriceHistory[index].admin.photoUrl!)
                                  : null,
                              child: editWastePriceHistory[index].admin.photoUrl == null ||
                                      editWastePriceHistory[index].admin.photoUrl == ''
                                  ? Text(
                                      editWastePriceHistory[index].admin.fullName![0].toUpperCase() +
                                          editWastePriceHistory[index].admin.fullName![1].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                      ),
                                    )
                                  : Container(),
                            ),
                          ),
                          Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2.5),
                            child: Expanded(
                              child: Text(
                                admin.id == editWastePriceHistory[index].admin.id
                                    ? 'Anda'
                                    : 'Admin ${editWastePriceHistory[index].admin.fullName}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              loadFailure: (_) => const Center(
                child: Text('Terjadi kesalahan'),
              ),
              orElse: () => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}
