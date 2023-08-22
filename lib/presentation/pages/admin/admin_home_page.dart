import 'package:bank_sampah/component/button/rounded_button.dart';
import 'package:bank_sampah/component/button/rounded_dropdown_button.dart';
import 'package:bank_sampah/component/dummy/dummy_data.dart';
import 'package:bank_sampah/core/constant/colors.dart';
import 'package:bank_sampah/core/constant/constant_data.dart';
import 'package:bank_sampah/core/constant/theme.dart';
import 'package:bank_sampah/core/routing/router.dart';
import 'package:bank_sampah/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:bank_sampah/presentation/bloc/report/report_bloc.dart';
import 'package:bank_sampah/presentation/pages/admin/pdf_api.dart';
import 'package:bank_sampah/presentation/pages/admin/pdf_report_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/report.dart';
import '../../../injection.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = context.read<AuthBloc>().state.whenOrNull(authenticated: (user) => user)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded, size: 32), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_rounded, size: 32), onPressed: () {}),
          Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              onTap: () => context.go('${AppRouterName.adminReportPath}/${AppRouterName.profilePath}'),
              child: Ink.image(
                width: 32,
                height: 32,
                image: CachedNetworkImageProvider(admin.photoUrl ??
                    'https://firebasestorage.googleapis.com/v0/b/banksampah-b3d01.appspot.com/o/profile-picture%2Ffigma-botts.png?alt=media&token=7611d9e3-3664-449e-8b97-feac1556d64c'),
              ),
            ),
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
                    context.read<ReportBloc>().add(ReportEvent.initial(timeSpan));
                  },
                );
              }),
              _buildSaldoDitarik(context),
              const SizedBox(height: 10),
              Text(
                'Total Sampah Terkumpul (900 kg)',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              _buildTotalSampah(context),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: RoundedButton(
                  name: 'Cetak Laporan',
                  onPressed: () async {
                    final transactions = DummyData.dummyTransaction;
                    final pdfFile = await PdfReportApi.generatePdf(transactions);

                    if (pdfFile.existsSync()) {
                      await PdfApi.openFile(pdfFile);
                    } else {
                      print('The PDF file was not generated successfully or doesn\'t exist.');
                    }
                  },
                  selected: true,
                  color: MyTheme.isDarkMode ? CColors.backgorundDark : CColors.backgorundLight,
                  textColor: MyTheme.isDarkMode ? CColors.primaryDark : CColors.primaryLight,
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
          Text(
            'Rp. 1.221.000',
            style: TextStyle(
              color: Theme.of(context).colorScheme.background,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSampah(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: (MediaQuery.of(context).size.width / 2) - 25,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
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
                Text(
                  '791 Kg',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Rp. 1.582.000',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context).size.width / 2) - 25,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
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
                Text(
                  '791 Kg',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Rp. 1.582.000',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
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
  final months = ConstantData.months;
  final years = ConstantData.years;
  String? valueMonth = ConstantData.months[DateTime.now().month - 1];
  String? valueYear = ConstantData.years.first;

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
