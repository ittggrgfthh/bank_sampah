import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../../core/utils/date_time_converter.dart';
import '../../../domain/entities/report.dart';
import 'pdf_api.dart';

class PdfReportApi {
  static Future<File> generatePdf(Report report) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(report),
        buildTable(report),
      ],
    ));

    return PdfApi.savePdf(name: 'report.pdf', pdf: pdf);
  }

  static Widget buildHeader(Report report) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dibuat: ${report.createdAtCity}, ${DateTimeConverter.millisecondEpochtoString(report.createdAt)}',
        ),
        SizedBox(height: 0.6 * PdfPageFormat.cm),
        Text(
          'Desa: ${report.village}',
        ),
        SizedBox(height: 0.6 * PdfPageFormat.cm),
        Text(
          'Rentang Waktu: ${DateTimeConverter.millisecondEpochtoDay(report.timeSpan.start)}, ${DateTimeConverter.millisecondEpochtoString(report.timeSpan.start)} - ${DateTimeConverter.millisecondEpochtoDay(report.timeSpan.end)}, ${DateTimeConverter.millisecondEpochtoString(report.timeSpan.end)}',
        ),
        SizedBox(height: 0.6 * PdfPageFormat.cm),
      ],
    );
  }

  static Widget buildTable(Report report) {
    final tableHeader = [
      'RT',
      'RW',
      'Organik',
      'An-Organik',
      'Tarik Saldo',
    ];

    final dataRow = report.rowsReport.map((row) {
      return [
        row.rt,
        row.rw,
        row.waste.organic.toString(),
        row.waste.inorganic.toString(),
        row.withdrawBalance.toString(),
      ];
    }).toList();

    dataRow.add([
      '',
      'Total',
      report.total.waste.organic.toString(),
      report.total.waste.inorganic.toString(),
      report.total.withdrawBalance.toString(),
    ]);

    return TableHelper.fromTextArray(
      headers: tableHeader,
      data: dataRow,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellDecoration: (index, data, rowNum) {
        if (rowNum == dataRow.length) {
          return const BoxDecoration(border: Border(top: BorderSide(width: 1)));
        }
        return const BoxDecoration();
      },
      border: null,
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
      },
    );
  }
}
