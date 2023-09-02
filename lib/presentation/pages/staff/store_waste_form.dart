import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/button/rounded_primary_button.dart';
import '../../../component/field/number_field.dart';
import '../../../component/widget/single_list_tile.dart';
import '../../../injection.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/list_user/list_user_bloc.dart';
import '../../bloc/store_waste_form/store_waste_form_bloc.dart';
import '../../bloc/transaction_history/transaction_history_bloc.dart';

class StoreWasteFormPage extends StatelessWidget {
  final String userId;
  const StoreWasteFormPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final staff = getIt<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
    return BlocProvider(
      create: (context) => getIt<StoreWasteFormBloc>()..add(StoreWasteFormEvent.initialized(userId, staff)),
      child: BlocListener<StoreWasteFormBloc, StoreWasteFormState>(
        listener: (context, state) {
          state.failureOrSuccessOption.fold(
            () => null,
            (failureOrSuccess) => failureOrSuccess.fold(
              (failure) => FlushbarHelper.createError(message: "Terjadi kesalahan").show(context),
              (_) {
                context.read<ListUserBloc>().add(const ListUserEvent.initialized('warga'));
                context.read<TransactionHistoryBloc>().add(TransactionHistoryEvent.initialized(staff.id));
                context.pop();
              },
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Form Simpan Sampah'),
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
                    child: BlocBuilder<StoreWasteFormBloc, StoreWasteFormState>(
                      builder: (context, state) {
                        return state.transaction.fold(() {
                          return state.failure.fold(
                            () => const CircularProgressIndicator(),
                            (failure) {
                              return failure.when(
                                timeout: () {
                                  return const Text('Timeout');
                                },
                                unexpected: (message, error, stackTrace) {
                                  return const Text('Terjadi kesalahan!');
                                },
                              );
                            },
                          );
                        }, (transaction) {
                          final user = transaction.user;
                          return SingleListTile(
                            photoUrl: user.photoUrl,
                            title: user.fullName ?? 'No Name',
                            subtitle: Text('+62 ${user.phoneNumber}'),
                            trailing: const Icon(Icons.chevron_right_rounded),
                          );
                        });
                      },
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
                  const StoreWasteForm(),
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
                BlocBuilder<StoreWasteFormBloc, StoreWasteFormState>(
                  buildWhen: (previous, current) {
                    return previous.isLoading != current.isLoading ||
                        previous.isChange != current.isChange ||
                        previous.user != current.user;
                  },
                  builder: (context, state) {
                    final user = state.user.toNullable();
                    if (user != null) {
                      final lastTransactionEpoch = user.lastTransactionEpoch ?? DateTime.now().millisecondsSinceEpoch;
                      const treeMinute = 5 * 60 * 1000;
                      final duration =
                          (((lastTransactionEpoch + treeMinute) - DateTime.now().millisecondsSinceEpoch) / 1000);
                      if (duration > 0) {
                        return RoundedPrimaryButton(
                          key: UniqueKey(),
                          isChanged: !state.isChange,
                          isLoading: state.isLoading,
                          buttonName: 'Simpan Sampah',
                          cooldownDuration: Duration(seconds: duration.toInt()),
                          onPressed: () {
                            context.read<StoreWasteFormBloc>().add(const StoreWasteFormEvent.submitButtonPressed());
                          },
                        );
                      } else {
                        return RoundedPrimaryButton(
                          isChanged: !state.isChange,
                          isLoading: state.isLoading,
                          buttonName: 'Simpan Sampah',
                          onPressed: () {
                            context.read<StoreWasteFormBloc>().add(const StoreWasteFormEvent.submitButtonPressed());
                          },
                        );
                      }
                    } else {
                      return RoundedPrimaryButton(
                        isChanged: !state.isChange,
                        isLoading: state.isLoading,
                        buttonName: 'Gagal Memuat User',
                        onPressed: null,
                      );
                    }
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
        BlocSelector<StoreWasteFormBloc, StoreWasteFormState, String>(
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

class StoreWasteForm extends StatefulWidget {
  const StoreWasteForm({
    super.key,
  });

  @override
  State<StoreWasteForm> createState() => _StoreWasteFormState();
}

class _StoreWasteFormState extends State<StoreWasteForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<StoreWasteFormBloc, StoreWasteFormState>(
          buildWhen: (previous, current) {
            return previous.priceOrganic != current.priceOrganic || previous.isLoading != current.isLoading;
          },
          builder: (context, state) {
            return NumberField(
              label: 'Organik',
              isLoading: state.isLoading,
              helperText: "Rp${context.read<StoreWasteFormBloc>().state.priceOrganic}/kg",
              onChanged: (value) {
                context.read<StoreWasteFormBloc>().add(StoreWasteFormEvent.organicWeightChanged(value));
              },
            );
          },
        ),
        const SizedBox(height: 15),
        BlocBuilder<StoreWasteFormBloc, StoreWasteFormState>(
          buildWhen: (previous, current) {
            return previous.priceInorganic != current.priceInorganic || previous.isLoading != current.isLoading;
          },
          builder: (context, state) {
            return NumberField(
              label: 'An-Organik',
              isLoading: state.isLoading,
              helperText: "Rp${context.read<StoreWasteFormBloc>().state.priceInorganic}/kg",
              onChanged: (value) {
                context.read<StoreWasteFormBloc>().add(StoreWasteFormEvent.inorganicWeightChanged(value));
              },
            );
          },
        ),
      ],
    );
  }
}
