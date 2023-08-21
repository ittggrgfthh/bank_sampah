import 'dart:io';

import 'package:bank_sampah/domain/entities/transaction_waste.dart';
import 'package:bank_sampah/presentation/pages/admin/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfReportApi {
  static Future<File> generatePdf(List<TransactionWaste> transaction) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(transaction),
      ],
    ));

    return PdfApi.savePdf(name: 'report.pdf', pdf: pdf);
  }

  static Widget buildHeader(List<TransactionWaste> transaction) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Dibuat: Semarang, 14 Agustus 2023',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text('Desa: Kebumen')
        ],
      );
}
