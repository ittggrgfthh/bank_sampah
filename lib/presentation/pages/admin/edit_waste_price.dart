import 'package:bank_sampah/core/routing/router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../component/button/rounded_primary_button.dart';
import '../../../component/field/money_field.dart';
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
          IconButton(icon: const Icon(Icons.notifications_rounded, size: 32), onPressed: () {}),
          Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              onTap: () => context.go('${AppRouterName.adminWastePricePath}/${AppRouterName.profilePath}'),
              child: Ink.image(
                width: 32,
                height: 32,
                image: CachedNetworkImageProvider(admin.photoUrl ??
                    'https://avatars.mds.yandex.net/i?id=1b0ce6ca8b11735031618d51e2a7e336f6d6f7b5-9291521-images-thumbs&n=13'),
              ),
            ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 5,
              children: [
                const Icon(Icons.access_time),
                BlocBuilder<EditWastePriceBloc, EditWastePriceState>(
                  buildWhen: (previous, current) => previous.currentTimeAgo != current.currentTimeAgo,
                  builder: (context, state) {
                    return Text('diperbarui ${state.currentTimeAgo}');
                  },
                ),
              ],
            ),
            Wrap(
              spacing: 5,
              children: [
                const Icon(Icons.group),
                BlocBuilder<EditWastePriceBloc, EditWastePriceState>(
                  buildWhen: (previous, current) => previous.currentAdminFullName != current.currentAdminFullName,
                  builder: (context, state) {
                    return Text('Oleh ${state.currentAdminFullName}');
                  },
                ),
              ],
            ),
          ],
        ),
        Container(
          width: 50,
          height: 50,
          child: IconButton(
            icon: const Icon(Icons.history),
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
