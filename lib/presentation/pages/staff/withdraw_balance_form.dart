import 'package:another_flushbar/flushbar_helper.dart';
import 'package:bank_sampah/component/button/rounded_choice_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../component/button/rounded_primary_button.dart';
import '../../../component/field/money_field.dart';
import '../../../core/constant/constant_data.dart';
import '../../../domain/entities/user.dart';
import '../../../injection.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/list_user/list_user_bloc.dart';
import '../../bloc/transaction_history/transaction_history_bloc.dart';
import '../../bloc/withdraw_balance_form/withdraw_balance_form_bloc.dart';

class WithdrawBalanceForm extends StatelessWidget {
  final User user;
  const WithdrawBalanceForm({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final staff = getIt<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarik Saldo'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left_rounded),
        ),
      ),
      body: BlocProvider(
        create: (context) => getIt<WithdrawBalanceFormBloc>()..add(WithdrawBalanceFormEvent.initialized(user, staff)),
        child: BlocListener<WithdrawBalanceFormBloc, WithdrawBalanceFormState>(
          listenWhen: (previous, current) => previous.isLoading != current.isLoading,
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
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildHeader(context),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Pilih Nominal',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              BlocBuilder<WithdrawBalanceFormBloc, WithdrawBalanceFormState>(
                builder: (context, state) {
                  return WithdrawChoiceChip(
                    balance: user.pointBalance.currentBalance,
                    onSelected: (value) {
                      context
                          .read<WithdrawBalanceFormBloc>()
                          .add(WithdrawBalanceFormEvent.withdrawBalanceChoiceChanged(value));
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Builder(builder: (context) {
                  return MoneyField(
                    hintText: 'Atau masukan nominal disini!',
                    validator: (_) {
                      return context
                          .read<WithdrawBalanceFormBloc>()
                          .state
                          .withdrwaBalanceValidator
                          .fold(() => null, (t) => t);
                    },
                    onChanged: (value) {
                      context
                          .read<WithdrawBalanceFormBloc>()
                          .add(WithdrawBalanceFormEvent.withdrwaBalanceChanged(value));
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              BlocBuilder<WithdrawBalanceFormBloc, WithdrawBalanceFormState>(
                buildWhen: (previous, current) =>
                    previous.isLoading != current.isLoading || previous.isChanged != current.isChanged,
                builder: (context, state) {
                  return RoundedPrimaryButton(
                    isLoading: state.isLoading,
                    isChanged: !state.isChanged,
                    buttonName: 'Tarik Saldo',
                    onPressed: () {
                      context.read<WithdrawBalanceFormBloc>().add(const WithdrawBalanceFormEvent.submitButtonPressed());
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Row(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blueAccent),
            child: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Text('AR'),
            ),
          ),
          const SizedBox(width: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.vertical,
            spacing: 10,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '+62 ${user.phoneNumber}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saldo',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    getIt<NumberFormat>().format(user.pointBalance.currentBalance),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class WithdrawChoiceChip extends StatefulWidget {
  final Function(int value)? onSelected;
  final int balance;
  const WithdrawChoiceChip({
    super.key,
    this.onSelected,
    this.balance = 1000000,
  });

  @override
  State<WithdrawChoiceChip> createState() => _WithdrawChoiceChipState();
}

class _WithdrawChoiceChipState extends State<WithdrawChoiceChip> {
  int? selectedChoice;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 5,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: List<Widget>.generate(
        ConstantData.withdrawChoice.length,
        (index) => RoundedChoiceButton(
          name: getIt<NumberFormat>().format(ConstantData.withdrawChoice[index]),
          selected: selectedChoice == index,
          onPressed: widget.balance < ConstantData.withdrawChoice[index]
              ? null
              : () => setState(() {
                    selectedChoice = index;
                    widget.onSelected?.call(ConstantData.withdrawChoice[index]);
                  }),
        ),
      ),
    );
  }
}
