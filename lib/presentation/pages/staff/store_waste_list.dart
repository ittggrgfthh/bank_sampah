import 'package:bank_sampah/component/button/rounded_button.dart';
import 'package:bank_sampah/core/constant/default_data.dart';
import 'package:bank_sampah/core/constant/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../component/widget/avatar_image.dart';
import '../../../component/widget/withdraw_balance_list_tile.dart';
import '../../../core/constant/colors.dart';
import '../../../core/routing/router.dart';
import '../../../injection.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/list_user/list_user_bloc.dart';

class StoreWasteListPage extends StatelessWidget {
  const StoreWasteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final staff = context.read<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simpan Sampah'),
        actions: [
          AvatarImage(
            onTap: () =>
                context.go('${AppRouterName.staffWasteTransactionPath}/${AppRouterName.profilePath}', extra: staff),
            photoUrl: staff.photoUrl,
            username: staff.fullName,
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 5,
              children: [
                SizedBox(
                  height: 26,
                  child: FilterButton(
                    label: 'Desa',
                    onPressed: () => showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => BuildModal(
                        item: DefaultData.village,
                        title: 'Filter Desa',
                        onSelectedChanged: (value) => print(value),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 26,
                  child: FilterButton(
                    label: 'RW',
                    onPressed: () => showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => BuildModal(
                        item: const ['001', '002', '003', '004'],
                        title: 'Filter RW',
                        onSelectedChanged: (value) => print(value),
                      ),
                    ),
                    backgroundColor: MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
                  ),
                ),
                SizedBox(
                  height: 26,
                  child: FilterButton(
                    label: 'RT',
                    onPressed: () => showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => BuildModal(
                        item: const ['001', '002', '003', '004'],
                        title: 'Filter RW',
                        onSelectedChanged: (value) => print(value),
                      ),
                    ),
                    backgroundColor: MyTheme.isDarkMode ? CColors.dangerDark : CColors.dangerLight,
                  ),
                ),
                Container(
                  height: 26,
                  width: 1,
                  color: CColors.shadow,
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ListUserBloc, ListUserState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loadSuccess: (users) {
                    if (users.isEmpty) {
                      return const Center(
                        child: Text('Tidak ada pengguna'),
                      );
                    }
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) => Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: CColors.shadow),
                          ),
                        ),
                        child: WithdrawBalanceListTile(
                          title: users[index].fullName ?? 'No Name',
                          subtitle: '+62 ${users[index].phoneNumber}',
                          trailing: ['Saldo', getIt<NumberFormat>().format(users[index].pointBalance.currentBalance)],
                          photoUrl: users[index].photoUrl,
                          onTap: () => context
                              .goNamed(AppRouterName.staffStoreWasteName, pathParameters: {'userId': users[index].id}),
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
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final Color? backgroundColor;

  const FilterButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        backgroundColor: MaterialStateProperty.all(backgroundColor ?? Theme.of(context).colorScheme.primary),
        foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          const Icon(Icons.arrow_drop_down, size: 12),
        ],
      ),
    );
  }
}

class BuildModal extends StatefulWidget {
  final List<String> item;
  final String title;
  final void Function(List<String>) onSelectedChanged;
  const BuildModal({
    super.key,
    required this.item,
    required this.title,
    required this.onSelectedChanged,
  });

  @override
  State<BuildModal> createState() => _BuildModalState();
}

class _BuildModalState extends State<BuildModal> {
  List<bool?> selectedValues = [];
  List<String> selectedOption = [];

  @override
  void initState() {
    super.initState();
    selectedValues = List<bool>.generate(widget.item.length, (index) => false);
  }

  void updateSelectedOptions() {
    List<String> selectedOptions = [];
    for (int i = 0; i < selectedValues.length; i++) {
      if (selectedValues[i] != null) {
        selectedOptions.add(widget.item[i]);
      }
    }
    widget.onSelectedChanged(selectedOptions); // Call the callback with selected options.
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(builder: (_, controller) {
      return Container(
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: widget.item.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(
                      widget.item[index],
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                    value: selectedValues[index],
                    onChanged: (value) => setState(() {
                      selectedValues[index] = value;

                      if (selectedValues[index]!) {
                        selectedOption.add(widget.item[index]);
                      } else {
                        selectedOption.remove(widget.item[index]);
                      }
                    }),
                  );
                },
              ),
            ),
            RoundedButton(
              name: 'Terapkan',
              onPressed: () {
                widget.onSelectedChanged.call(selectedOption);
              },
              selected: true,
              color: Theme.of(context).colorScheme.background,
              textColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      );
    });
  }
}
