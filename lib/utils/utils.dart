import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../module/pdfview_screen.dart';

class Utils {
  static Future openLink({required String Url}) => _launchUrl(Url);

  static Future downloadPdf(
          {required String pdfName, required BuildContext context}) =>
      _downloadPdf(pdfName, context);

  static Future _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  static _openPdf(BuildContext context, String pdfName, File file) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PdfViewScreen(
          file: file,
          pdfName: pdfName,
        ),
      ),
    );
  }

  static Future _downloadPdf(String pdfName, BuildContext context) async {
    /*try {
      final storageRef = FirebaseStorage.instance.ref();
      final pdfRef = storageRef.child("Interview's Q&A/${pdfName}.pdf");

      final bytes = await pdfRef.getData();
      print(pdfRef);

      final appDocDir = await getExternalStorageDirectory();
      final filePath = "${appDocDir!.path}/${pdfName}.pdf";
      final file = File(filePath);

      await file.writeAsBytes(bytes!, flush: true);

      _openPdf(context, pdfName, file);
      // await pdfRef.writeToFile(file);

      showToast('File is downloaded');
      // OpenFile.open(filePath);
      //     // TODO: Handle this case.
    } catch (error) {
      showToast(error.toString());
    }*/
  }
}
