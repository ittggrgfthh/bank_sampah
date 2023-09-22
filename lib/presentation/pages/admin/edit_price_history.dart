import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/widget/avatar_image.dart';
import '../../../component/widget/transaction_histry_list_tile.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/theme.dart';
import '../../../core/utils/app_helper.dart';
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
                      title: Text(AppHelper.millisecondEpochtoString(editWastePriceHistory[index].createdAt)),
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
                          AvatarImage(
                            photoUrl: editWastePriceHistory[index].admin.photoUrl,
                            username: editWastePriceHistory[index].admin.fullName,
                            size: 20,
                          ),
                          Text(
                            admin.id == editWastePriceHistory[index].admin.id
                                ? 'Anda'
                                : 'Admin ${editWastePriceHistory[index].admin.fullName}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              overflow: TextOverflow.ellipsis,
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
