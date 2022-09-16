import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/models/course_details.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';
import 'pdfview_screen.dart';

class PdfCourseScreen extends StatefulWidget {
  final Map<String, dynamic> curriculum;
  const PdfCourseScreen({Key? key, required this.curriculum}) : super(key: key);

  @override
  State<PdfCourseScreen> createState() => _PdfCourseScreenState();
}

class _PdfCourseScreenState extends State<PdfCourseScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: false,
              backgroundColor: Colors.white,
              expandedHeight: 150,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(
                  left: 50,
                  top: 100,
                ),
                centerTitle: true,
                title: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        // size: 30 * min(horizontalScale, verticalScale),
                      ),
                    ),
                    SizedBox(width: 10),
                    Center(
                      child: Text(
                        'Interview\'s Q & A',
                        // textScaleFactor: min(horizontalScale, verticalScale),
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontFamily: 'Poppins',
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                collapseMode: CollapseMode.parallax,
                background: Container(
                  width: 414 * horizontalScale,
                  // height: 217 * verticalScale,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    color: Color.fromRGBO(122, 98, 222, 1),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -15 * verticalScale,
                        right: -15 * horizontalScale,
                        child: Container(
                          width: 128 * min(horizontalScale, verticalScale),
                          height: 128 * min(verticalScale, horizontalScale),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(129, 105, 229, 1),
                            borderRadius: BorderRadius.all(
                              Radius.elliptical(128, 128),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 80 * verticalScale,
                        left: -31 * horizontalScale,
                        child: Container(
                          width: 62 * min(horizontalScale, verticalScale),
                          height: 62 * min(verticalScale, horizontalScale),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(129, 105, 229, 1),
                            borderRadius: BorderRadius.all(
                              Radius.elliptical(62, 62),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          removeLeft: true,
          removeRight: true,
          removeTop: true,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.curriculum['Company Names'].length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                autofocus: true,
                trailing: IconButton(
                  onPressed: () => Utils.downloadPdf(
                    context: context,
                    pdfName: widget.curriculum['Company Names'][index],
                  ),
                  icon: Icon(
                    Icons.download_for_offline,
                  ),
                ),
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(132, 193, 170, 245),
                  ),
                  width: 50,
                  height: 50,
                  child: Center(
                    child: Text('${index + 1}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                enableFeedback: true,
                title: Text(
                  widget.curriculum['Company Names'][index],
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: 'Poppins',
                    letterSpacing: 0,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
