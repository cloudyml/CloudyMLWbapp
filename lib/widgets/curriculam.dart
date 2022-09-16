import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/helpers/file_handler.dart';
import 'package:cloudyml_app2/widgets/demo_video.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:flutter/material.dart';

import '../models/course_details.dart';
import '../utils/utils.dart';

class Curriculam extends StatefulWidget {
  final CourseDetails courseDetail;

  const Curriculam({
    Key? key,
    required this.courseDetail,
  }) : super(key: key);

  @override
  State<Curriculam> createState() => _CurriculamState();
}

class _CurriculamState extends State<Curriculam> {
  bool showMore = false;
  Map<String, dynamic>? topicDetails;

  String? modId;

  get name => null;

  void openDemoVideos({
    required int index,
    required BuildContext context,
  }) async {
    Map<String, dynamic> topicDetails;
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('Modules')
        .doc(modId)
        .collection('Topics')
        .where('sr', isEqualTo: index + 1)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        topicDetails = value.docs[0].data();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerCustom(
              url: topicDetails['url'],
            ),
          ),
        );
      }
    });
  }

  void getModuleId() async {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('Modules')
        .where('firstType', isEqualTo: 'video')
        .get()
        .then((value) {
      setState(() {
        if (value.docs.isNotEmpty) {
          modId = value.docs[0].id;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.courseDetail.curriculum);
    getModuleId();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Curriculum',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Medium',
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                    widget.courseDetail.curriculum['sectionsName'].length,
                itemBuilder: (context, index1) {
                  return Column(
                    children: [
                      SizedBox(height: 8),
                      Container(
                        // height: 30,
                        child: Row(
                          children: [
                            Text(
                              widget.courseDetail.curriculum['sectionsName']
                                  [index1],
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Medium',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: showMore ? null : 200,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget
                                  .courseDetail
                                  .curriculum[
                                      '${widget.courseDetail.curriculum['sectionsName'][index1]}']
                                  .length,
                              itemBuilder: ((context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 22,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(0),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            flex: 1, //
                                            child: Text('${index + 1} : '),
                                          ),
                                          Expanded(
                                            flex: 10,
                                            child: Text(
                                              widget.courseDetail.curriculum[
                                                      '${widget.courseDetail.curriculum['sectionsName'][index1]}']
                                                  [index],
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Medium',
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () async {
                                                if (index < 3 && index1 == 0) {
                                                  if (widget.courseDetail
                                                          .courseContent ==
                                                      'pdf') {
                                                    Utils.downloadPdf(
                                                      context: context,
                                                      pdfName: widget
                                                                  .courseDetail
                                                                  .curriculum[
                                                              'Company Names']
                                                          [index],
                                                    );
                                                  } else {
                                                    openDemoVideos(
                                                      index: index,
                                                      context: context,
                                                    );
                                                  }
                                                }
                                              },
                                              child: Icon(
                                                !(widget.courseDetail
                                                            .courseContent ==
                                                        'pdf')
                                                    ? Icons
                                                        .play_circle_fill_outlined
                                                    : Icons.assignment_sharp,
                                                color: index <= 2 && index1 == 0
                                                    ? Color(0xFF7860DC)
                                                    : null,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                          widget
                                      .courseDetail
                                      .curriculum![
                                          '${widget.courseDetail.curriculum['sectionsName'][index1]}']
                                      .length >
                                  4
                              ? TextButton(
                                  onPressed: () {
                                    setState(() {
                                      if (index1 == index1) {
                                        showMore = !showMore;
                                      }
                                    });
                                  },
                                  child: showMore
                                      ? Text('Show less')
                                      : Text('Show more'),
                                )
                              : Container()
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
