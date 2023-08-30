import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/button/rounded_primary_button.dart';
import '../../../component/field/money_field.dart';
import '../../../component/widget/avatar_image.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/theme.dart';
import '../../../core/routing/router.dart';
import '../../../injection.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/edit_waste_price/edit_waste_price_bloc.dart';

class EditWastePrice extends StatelessWidget {
  const EditWastePrice({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = getIt<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Harga'),
        actions: [
          AvatarImage(
            photoUrl: admin.photoUrl,
            username: admin.fullName,
            onTap: () => context.go('${AppRouterName.adminReportPath}/${AppRouterName.profilePath}', extra: admin),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: BlocProvider(
          create: (context) => getIt<EditWastePriceBloc>()..add(EditWastePriceEvent.initialized(admin)),
          child: Wrap(
            runSpacing: 20,
            children: [
              _buildHeader(context),
              const EditWastePriceForm(),
              BlocBuilder<EditWastePriceBloc, EditWastePriceState>(
                buildWhen: (previous, current) {
                  return previous.isChange != current.isChange || previous.isLoading != current.isLoading;
                },
                builder: (context, state) {
                  return RoundedPrimaryButton(
                      isLoading: state.isLoading,
                      isChanged: !state.isChange,
                      buttonName: 'Simpan',
                      onPressed: () {
                        context.read<EditWastePriceBloc>().add(const EditWastePriceEvent.submitButtonPressed());
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: width - (width / 3)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 20),
                  const SizedBox(width: 5),
                  BlocBuilder<EditWastePriceBloc, EditWastePriceState>(
                    buildWhen: (previous, current) => previous.currentTimeAgo != current.currentTimeAgo,
                    builder: (context, state) {
                      return Expanded(
                        child: Text(
                          'diperbarui ${state.currentTimeAgo}',
                          style: const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 14),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.group, size: 20),
                  const SizedBox(width: 5),
                  BlocBuilder<EditWastePriceBloc, EditWastePriceState>(
                    buildWhen: (previous, current) => previous.currentAdminFullName != current.currentAdminFullName,
                    builder: (context, state) {
                      return Expanded(
                        child: Text(
                          'Oleh ${state.currentAdminFullName}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: Icon(
              Icons.history_rounded,
              size: 50,
              color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
            ),
            onPressed: () => context.goNamed(AppRouterName.adminWastePriceLogName),
          ),
        ),
      ],
    );
  }
}

class EditWastePriceForm extends StatefulWidget {
  const EditWastePriceForm({
    super.key,
  });

  @override
  State<EditWastePriceForm> createState() => _EditWastePriceFormState();
}

class _EditWastePriceFormState extends State<EditWastePriceForm> {
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
    return Wrap(
      runSpacing: 8,
      children: [
        const Text('Organik (Rp)'),
        BlocBuilder<EditWastePriceBloc, EditWastePriceState>(
          buildWhen: (previous, current) =>
              previous.priceOrganic != current.priceOrganic || previous.isLoading != current.isLoading,
          builder: (context, state) {
            if (!state.isChange) {
              _priceOrganicController.text = state.priceOrganic;
            }
            return MoneyField(
              isLoading: state.isLoading,
              controller: _priceOrganicController,
              suffixText: 'per kg',
              onChanged: (value) {
                context.read<EditWastePriceBloc>().add(EditWastePriceEvent.priceOrganicChanged(value));
              },
            );
          },
        ),
        const Text('An-Organik (Rp)'),
        BlocBuilder<EditWastePriceBloc, EditWastePriceState>(
          buildWhen: (previous, current) =>
              previous.priceInorganic != current.priceInorganic || previous.isLoading != current.isLoading,
          builder: (context, state) {
            if (!state.isChange) {
              _priceInorganicController.text = state.priceInorganic;
            }
            return MoneyField(
              isLoading: state.isLoading,
              controller: _priceInorganicController,
              suffixText: 'per kg',
              onChanged: (value) {
                context.read<EditWastePriceBloc>().add(EditWastePriceEvent.priceInorganicChanged(value));
              },
            );
          },
        ),
      ],
    );
  }
}
