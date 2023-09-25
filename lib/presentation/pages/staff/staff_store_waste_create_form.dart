import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/button/rounded_primary_button.dart';
import '../../../component/field/number_field.dart';
import '../../../component/widget/single_list_tile.dart';
import '../../../core/utils/app_helper.dart';
import '../../../injection.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/filter_user/filter_user_bloc.dart';
import '../../bloc/store_waste_form/store_waste_form_bloc.dart';

class StaffStoreWasteCreateForm extends StatelessWidget {
  final String userId;
  const StaffStoreWasteCreateForm({super.key, required this.userId});

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
                context.read<FilterUserBloc>().add(const FilterUserEvent.loaded());
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
                        previous.isChanged != current.isChanged ||
                        previous.user != current.user;
                  },
                  builder: (context, state) {
                    return state.user.fold(
                      () => RoundedPrimaryButton(
                        isChanged: !state.isChanged,
                        isLoading: state.isLoading,
                        buttonName: 'Gagal Memuat User',
                        onPressed: null,
                      ),
                      (user) {
                        final Duration? duration = AppHelper.getDurationLastTransactionEpoch(user.lastTransactionEpoch);
                        return RoundedPrimaryButton(
                          key: duration == null ? null : UniqueKey(),
                          isChanged: !state.isChanged,
                          isLoading: state.isLoading,
                          buttonName: 'Simpan Sampah',
                          cooldownDuration: duration,
                          onPressed: () {
                            context.read<StoreWasteFormBloc>().add(const StoreWasteFormEvent.submitButtonPressed());
                          },
                        );
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

class StoreWasteForm extends StatelessWidget {
  const StoreWasteForm({
    super.key,
  });

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
