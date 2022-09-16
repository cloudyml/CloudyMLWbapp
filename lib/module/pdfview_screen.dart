import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewScreen extends StatelessWidget {
  final File file;
  final String pdfName;
  const PdfViewScreen({
    Key? key,
    required this.file,
    required this.pdfName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC0AAF5),
        title: Text(pdfName),
      ),
      body: PDFView(
        filePath: file.path,
        pageFling: false,
      ),
    );
  }
}
