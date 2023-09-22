import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/button/rounded_primary_button.dart';
import '../../../component/field/number_field.dart';
import '../../../component/widget/single_list_tile.dart';
import '../../../domain/entities/transaction_waste.dart';
import '../../../injection.dart';
import '../../bloc/edit_store_waste_form/edit_store_waste_form_bloc.dart';
import '../../bloc/filter_transaction_waste/filter_transaction_waste_bloc.dart';
import '../../bloc/filter_user/filter_user_bloc.dart';
import '../../bloc/list_user/list_user_bloc.dart';
import '../../bloc/transaction_history/transaction_history_bloc.dart';

class EditStoreWasteFormPage extends StatelessWidget {
  final TransactionWaste transaction;
  const EditStoreWasteFormPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EditStoreWasteFormBloc>()..add(EditStoreWasteFormEvent.initialized(transaction)),
      child: BlocListener<EditStoreWasteFormBloc, EditStoreWasteFormState>(
        listener: (context, state) {
          state.failureOrSuccessOption.fold(
            () => null,
            (failureOrSuccess) => failureOrSuccess.fold(
              (failure) => FlushbarHelper.createError(message: "Terjadi kesalahan").show(context),
              (_) {
                final filterUser = getIt<FilterUserBloc>().state.whenOrNull(loadSuccess: (filter) => filter)!;
                context.read<ListUserBloc>().add(ListUserEvent.initialized(filterUser));
                final filterTransactionWaste =
                    getIt<FilterTransactionWasteBloc>().state.whenOrNull(loadSuccess: (filter) => filter)!;
                context.read<TransactionHistoryBloc>().add(TransactionHistoryEvent.filterChanged(
                    filterTransactionWaste.copyWith(staffId: transaction.staff.id)));
                context.pop();
              },
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Form Edit Sampah'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            reverse: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SingleListTile(
                      photoUrl: transaction.user.photoUrl,
                      title: transaction.user.fullName ?? 'No Name',
                      subtitle: Text('+62 ${transaction.user.phoneNumber}'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Berat Sampah',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const EditStoreWasteForm(),
                  const SizedBox(height: 100),
                ],
              ),
            ],
          ),
          bottomSheet: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _totalMoney(context),
                const SizedBox(height: 10),
                BlocBuilder<EditStoreWasteFormBloc, EditStoreWasteFormState>(
                  buildWhen: (previous, current) {
                    return previous.isLoading != current.isLoading || previous.isChange != current.isChange;
                  },
                  builder: (context, state) {
                    return RoundedPrimaryButton(
                      isChanged: !state.isChange,
                      isLoading: state.isLoading,
                      buttonName: 'Simpan Sampah',
                      onPressed: () {
                        context.read<EditStoreWasteFormBloc>().add(const EditStoreWasteFormEvent.submitButtonPressed());
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _totalMoney(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Total saldo yang diperoleh',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        BlocSelector<EditStoreWasteFormBloc, EditStoreWasteFormState, String>(
            selector: (state) => state.earnedBalance,
            builder: (context, earnedBalance) {
              return Text(
                'Rp$earnedBalance',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              );
            }),
      ],
    );
  }
}

class EditStoreWasteForm extends StatefulWidget {
  const EditStoreWasteForm({
    super.key,
  });

  @override
  State<EditStoreWasteForm> createState() => _EditStoreWasteFormState();
}

class _EditStoreWasteFormState extends State<EditStoreWasteForm> {
  final TextEditingController _priceOrganicController = TextEditingController();
  final TextEditingController _priceInorganicController = TextEditingController();

  @override
  void dispose() {
    _priceOrganicController.dispose();
    _priceInorganicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<EditStoreWasteFormBloc, EditStoreWasteFormState>(
          buildWhen: (previous, current) {
            return previous.priceOrganic != current.priceOrganic || previous.isLoading != current.isLoading;
          },
          builder: (context, state) {
            _priceOrganicController.text = state.organicWeight;
            return NumberField(
              controller: _priceOrganicController,
              label: 'Organik',
              isLoading: state.isLoading,
              helperText: "Rp${context.read<EditStoreWasteFormBloc>().state.priceOrganic}/kg",
              onChanged: (value) {
                context.read<EditStoreWasteFormBloc>().add(EditStoreWasteFormEvent.organicWeightChanged(value));
              },
            );
          },
        ),
        const SizedBox(height: 15),
        BlocBuilder<EditStoreWasteFormBloc, EditStoreWasteFormState>(
          buildWhen: (previous, current) {
            return previous.priceInorganic != current.priceInorganic || previous.isLoading != current.isLoading;
          },
          builder: (context, state) {
            _priceInorganicController.text = state.inorganicWeight;
            return NumberField(
              controller: _priceInorganicController,
              label: 'An-Organik',
              isLoading: state.isLoading,
              helperText: "Rp${context.read<EditStoreWasteFormBloc>().state.priceInorganic}/kg",
              onChanged: (value) {
                context.read<EditStoreWasteFormBloc>().add(EditStoreWasteFormEvent.inorganicWeightChanged(value));
              },
            );
          },
        ),
      ],
    );
  }
}
