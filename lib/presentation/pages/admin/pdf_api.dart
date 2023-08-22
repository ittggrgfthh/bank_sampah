import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> savePdf({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    try {
      await OpenFile.open(url);
    } catch (e) {
      Text('Error opening PDF: $e');
    }
  }
}
