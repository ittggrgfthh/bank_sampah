import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../component/button/rounded_button.dart';
import '../../../component/button/rounded_dropdown_button.dart';
import '../../../component/widget/avatar_image.dart';
import '../../../component/widget/dropdown_village.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/default_data.dart';
import '../../../core/constant/theme.dart';
import '../../../core/routing/router.dart';
import '../../../domain/entities/report.dart';
import '../../../injection.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/report/report_bloc.dart';
import 'pdf_api.dart';
import 'pdf_report_api.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = context.read<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        actions: [
          AvatarImage(
            photoUrl: admin.photoUrl,
            username: admin.fullName,
            onTap: () => context.goNamed(AppRouterName.profileName),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: BlocProvider(
        create: (context) => getIt<ReportBloc>(),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            shrinkWrap: true,
            children: [
              Builder(builder: (context) {
                return ChooseTimeRange(
                  onChanged: (startEpoch, endEpoch) {
                    final timeSpan = TimeSpan(start: startEpoch, end: endEpoch);
                    context.read<ReportBloc>().add(ReportEvent.chooseTimeRange(timeSpan));
                  },
                );
              }),
              Builder(builder: (context) {
                return DropdownVillage(onChanged: (village) {
                  context.read<ReportBloc>().add(ReportEvent.chooseVillage(village));
                });
              }),
              const SizedBox(height: 20),
              _buildSaldoDitarik(context),
              const SizedBox(height: 10),
              BlocSelector<ReportBloc, ReportState, String>(
                selector: (state) {
                  return state.totalWasteStored;
                },
                builder: (context, totalWasteStored) {
                  return Text(
                    'Total Sampah Terkumpul ($totalWasteStored kg)',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildTotalSampah(context),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: BlocBuilder<ReportBloc, ReportState>(
                  buildWhen: (previous, current) => previous.isLoading != current.isLoading,
                  builder: (context, state) {
                    return RoundedButton(
                      name: 'Cetak Laporan',
                      onPressed: state.isLoading
                          ? null
                          : () async {
                              final report = state.report.toNullable();
                              if (report == null) {
                                return;
                              }
                              final pdfFile = await PdfReportApi.generatePdf(report);

                              if (pdfFile.existsSync()) {
                                await PdfApi.openFile(pdfFile);
                              } else {
                                const SnackBar(
                                  content: Text('The PDF file was not generated successfully or doesn\'t exist.'),
                                );
                              }
                            },
                      selected: true,
                      color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
                      textColor: MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaldoDitarik(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.wallet_rounded,
                color: Theme.of(context).colorScheme.background,
                size: 20,
              ),
              Text(
                'Total Saldo ditarik',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              )
            ],
          ),
          BlocSelector<ReportBloc, ReportState, String>(
            selector: (state) {
              return state.totalWithdrawBalance;
            },
            builder: (context, totalWithdrawBalance) {
              return Text(
                'Rp$totalWithdrawBalance',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSampah(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          width: (MediaQuery.of(context).size.width / 2) - 25,
          decoration: BoxDecoration(
            color: MyTheme.isDarkMode ? CColors.successDark : CColors.successLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 5,
                children: [
                  Icon(
                    Icons.wallet_rounded,
                    color: Theme.of(context).colorScheme.background,
                    size: 20,
                  ),
                  Text(
                    'Organik',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              BlocSelector<ReportBloc, ReportState, String>(
                selector: (state) {
                  return state.totalOrganic;
                },
                builder: (context, totalOrganic) {
                  return Text(
                    '${totalOrganic}Kg',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
              BlocSelector<ReportBloc, ReportState, String>(
                selector: (state) {
                  return state.totalOrganicBalance;
                },
                builder: (context, totalOrganicBalance) {
                  return Text(
                    'Rp$totalOrganicBalance',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          width: (MediaQuery.of(context).size.width / 2) - 25,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: MyTheme.isDarkMode ? CColors.warningDark : CColors.warningLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 5,
                children: [
                  Icon(
                    Icons.wallet_rounded,
                    color: Theme.of(context).colorScheme.background,
                    size: 20,
                  ),
                  Text(
                    'An-Organik',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              BlocSelector<ReportBloc, ReportState, String>(
                selector: (state) {
                  return state.totalInorganic;
                },
                builder: (context, totalInorganic) {
                  return Text(
                    '${totalInorganic}Kg',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
              BlocSelector<ReportBloc, ReportState, String>(
                selector: (state) {
                  return state.totalInorganicBalance;
                },
                builder: (context, totalInorganicBalance) {
                  return Text(
                    'Rp$totalInorganicBalance',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChooseTimeRange extends StatefulWidget {
  final Function(int startEpoch, int endEpoch)? onChanged;

  const ChooseTimeRange({
    super.key,
    this.onChanged,
  });

  @override
  State<ChooseTimeRange> createState() => _ChooseTimeRangeState();
}

class _ChooseTimeRangeState extends State<ChooseTimeRange> {
  final months = DefaultData.months;
  final years = DefaultData.years;
  String? valueMonth = DefaultData.months[DateTime.now().month - 1];
  String? valueYear = DefaultData.years.first;

  @override
  Widget build(BuildContext context) {
    String dateString = "${valueYear!}/${(months.indexOf(valueMonth!) + 1)}/1 00:00:00";
    DateFormat format = DateFormat("yyyy/M/d H:m:s");
    DateTime dateTime = format.parse(dateString);
    widget.onChanged
        ?.call(dateTime.millisecondsSinceEpoch, dateTime.copyWith(month: dateTime.month + 1).millisecondsSinceEpoch);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 41,
            width: (MediaQuery.of(context).size.width / 2) - 25,
            child: RoundedDropdownButton(
              items: months,
              onChanged: (value) => setState(() => valueMonth = value),
              value: valueMonth,
            ),
          ),
          SizedBox(
            height: 41,
            width: (MediaQuery.of(context).size.width / 2) - 25,
            child: RoundedDropdownButton(
              items: years,
              onChanged: (value) => setState(() => valueYear = value),
              value: valueYear,
            ),
          ),
        ],
      ),
    );
  }
}
