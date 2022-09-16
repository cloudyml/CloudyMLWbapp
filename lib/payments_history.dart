import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/catalogue_screen.dart';
import 'package:cloudyml_app2/combo/combo_store.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/models/course_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  List<dynamic> courses = [];

  bool? load = true;

  void fetchCourses() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        courses = value.data()!['paidCourseNames'];
        load = false;
      });
    });
    print('The courses are--$courses');
  }

  Map userMap = Map<String, dynamic>();
  void dbCheckerForPayInParts() async {
    DocumentSnapshot userDocs = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      userMap = userDocs.data() as Map<String, dynamic>;
    });
    print('Usermap is--$userMap');
  }

  void initState() {
    super.initState();
    fetchCourses();
    dbCheckerForPayInParts();
  }

  @override
  Widget build(BuildContext context) {
    List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -147 * verticalScale,
            left: 0,
            child: Container(
              width: 414 * horizontalScale,
              height: 414 * verticalScale,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                color: Color.fromRGBO(122, 98, 222, 1),
              ),
            ),
          ),
          Positioned(
            top: 115 * verticalScale,
            left: 63 * horizontalScale,
            child: Text(
              'Payment History',
              textAlign: TextAlign.center,
              textScaleFactor: min(horizontalScale, verticalScale),
              style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: 'Poppins',
                  fontSize: 35,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.w500,
                  height: 1),
            ),
          ),
          Positioned(
            top: 26 * verticalScale,
            left: 294 * horizontalScale,
            child: Container(
              width: 30 * min(horizontalScale, verticalScale),
              height: 30 * min(horizontalScale, verticalScale),
              decoration: BoxDecoration(
                color: Color.fromRGBO(127, 106, 228, 1),
                borderRadius: BorderRadius.all(Radius.elliptical(30, 30)),
              ),
            ),
          ),
          Positioned(
            top: 101 * verticalScale,
            left: 358 * horizontalScale,
            child: Container(
              width: 20 * min(horizontalScale, verticalScale),
              height: 20 * min(horizontalScale, verticalScale),
              decoration: BoxDecoration(
                color: Color.fromRGBO(127, 106, 228, 1),
                borderRadius: BorderRadius.all(Radius.elliptical(20, 20)),
              ),
            ),
          ),
          Positioned(
            top: 206 * verticalScale,
            left: 378 * horizontalScale,
            child: Container(
              width: 8 * min(horizontalScale, verticalScale),
              height: 8 * min(horizontalScale, verticalScale),
              decoration: BoxDecoration(
                color: Color.fromRGBO(127, 106, 228, 1),
                borderRadius: BorderRadius.all(
                  Radius.elliptical(8, 8),
                ),
              ),
            ),
          ),
          Positioned(
            top: 180 * verticalScale,
            left: 310 * horizontalScale,
            child: Container(
              width: 14 * min(horizontalScale, verticalScale),
              height: 15 * min(horizontalScale, verticalScale),
              decoration: BoxDecoration(
                color: Color.fromRGBO(127, 106, 228, 1),
                borderRadius: BorderRadius.all(
                  Radius.elliptical(14, 15),
                ),
              ),
            ),
          ),
          Positioned(
            top: 209 * verticalScale,
            left: 72 * horizontalScale,
            child: Container(
              width: 271 * horizontalScale,
              height: 107 * verticalScale,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(29, 28, 31, 0.3),
                      offset: Offset(2, 2),
                      blurRadius: 50)
                ],
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
          ),
          Positioned(
            top: 270 * verticalScale,
            left: 111 * horizontalScale,
            child: Text(
              'Successful',
              textAlign: TextAlign.left,
              textScaleFactor: horizontalScale,
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
          Positioned(
            top: 232 * verticalScale,
            left: 133 * horizontalScale,
            child: Container(
                width: 37 * min(horizontalScale, verticalScale),
                height: 37 * min(horizontalScale, verticalScale),
                decoration: BoxDecoration(
                  color: Color(0xFF14F5A4),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                )),
          ),
          Positioned(
            top: 270 * verticalScale,
            left: 239 * horizontalScale,
            child: Text(
              'Pending',
              textAlign: TextAlign.left,
              textScaleFactor: horizontalScale,
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
          Positioned(
            top: 232 * verticalScale,
            right: 133 * horizontalScale,
            child: Container(
                width: 37 * min(horizontalScale, verticalScale),
                height: 37 * min(horizontalScale, verticalScale),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(241, 54, 88, 1),
                  borderRadius: BorderRadius.all(Radius.elliptical(33, 33)),
                ),
                child: Icon(
                  CupertinoIcons.exclamationmark,
                  color: Colors.white,
                )),
          ),
          courses.length > 0
              ? Positioned(
                  top: 0 * verticalScale,
                  left: 0 * horizontalScale,
                  child: Container(
                    width: screenWidth,
                    height: screenHeight,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // shrinkWrap: true,
                      itemCount: course.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (course[index].courseName == "null") {
                          return Container();
                        }
                        if (courses.contains(course[index].courseId)) {
                          return Stack(
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 345 * verticalScale,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        width: 177 * horizontalScale,
                                        height: 92 * verticalScale,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            topRight: Radius.circular(25),
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(0),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    29, 28, 31, 0.3),
                                                offset: Offset(2, 2),
                                                blurRadius: 47)
                                          ],
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                course[index].courseImageUrl,
                                              ),
                                              fit: BoxFit.fitWidth),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            width: 177 * horizontalScale,
                                            height: 200 * verticalScale / 2,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                // topLeft: Radius.circular(25),
                                                // topRight: Radius.circular(25),
                                                bottomLeft: Radius.circular(25),
                                                bottomRight:
                                                    Radius.circular(25),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color.fromRGBO(
                                                      29,
                                                      28,
                                                      31,
                                                      0.3,
                                                    ),
                                                    offset: Offset(2, 2),
                                                    blurRadius: 47)
                                              ],
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                            ),
                                          ),
                                          Positioned(
                                            top: 5 * verticalScale,
                                            left: 10 * horizontalScale,
                                            right: 10 * horizontalScale,
                                            child: Container(
                                              child: Text(
                                                course[index].courseName,
                                                textScaleFactor:
                                                    horizontalScale,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1),
                                                    fontFamily: 'Poppins',
                                                    fontSize: 15,
                                                    letterSpacing:
                                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1),
                                                // overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 35 * verticalScale,
                                            left: 10 * horizontalScale,
                                            right: 40 * horizontalScale,
                                            child: Divider(
                                              thickness: 1.5,
                                            ),
                                          ),
                                          Positioned(
                                            top: 50 * verticalScale,
                                            left: 10 * horizontalScale,
                                            right: 10 * horizontalScale,
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Amount Paid : ',
                                                    textScaleFactor:
                                                        horizontalScale,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFC0AAF5),
                                                        fontFamily: 'Poppins',
                                                        fontSize: 12,
                                                        letterSpacing:
                                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1),
                                                    // overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    course[index].coursePrice,
                                                    textScaleFactor:
                                                        horizontalScale,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFC0AAF5),
                                                        fontFamily: 'Poppins',
                                                        fontSize: 12,
                                                        letterSpacing:
                                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1),
                                                    // overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 65 * verticalScale,
                                            left: 10 * horizontalScale,
                                            right: 10 * horizontalScale,
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Offers : ',
                                                    textScaleFactor:
                                                        horizontalScale,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFC0AAF5),
                                                        fontFamily: 'Poppins',
                                                        fontSize: 12,
                                                        letterSpacing:
                                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1),
                                                    // overflow: TextOverflow.ellipsis,
                                                  ),
                                                  userMap['couponCodeDetails'][
                                                              course[index]
                                                                  .courseId] ==
                                                          null
                                                      ? Text(
                                                          'none',
                                                          textScaleFactor:
                                                              horizontalScale,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFFC0AAF5),
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 12,
                                                              letterSpacing:
                                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 1),
                                                          // overflow: TextOverflow.ellipsis,
                                                        )
                                                      : Text(
                                                          userMap['couponCodeDetails']
                                                                  [course[index]
                                                                      .courseId]
                                                              [
                                                              'couponCodeApplied'],
                                                          textScaleFactor:
                                                              horizontalScale,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFFC0AAF5),
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 12,
                                                              letterSpacing:
                                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 1),
                                                          // overflow: TextOverflow.ellipsis,
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 175 * horizontalScale,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 510 *
                                            min(horizontalScale, verticalScale),
                                      ),
                                      userMap['payInPartsDetails'][
                                                      course[index].courseId] !=
                                                  null &&
                                              !userMap['payInPartsDetails']
                                                      [course[index].courseId]
                                                  ['outStandingAmtPaid']
                                          ? Container(
                                              width: 37 *
                                                  min(
                                                    horizontalScale,
                                                    verticalScale,
                                                  ),
                                              height: 37 *
                                                  min(
                                                    horizontalScale,
                                                    verticalScale,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    241, 54, 88, 1),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Icon(
                                                CupertinoIcons.exclamationmark,
                                                color: Colors.white,
                                              ))
                                          : Container(
                                              width: 37 *
                                                  min(horizontalScale,
                                                      verticalScale),
                                              height: 37 *
                                                  min(horizontalScale,
                                                      verticalScale),
                                              decoration: BoxDecoration(
                                                color: Color(0xFF14F5A4),
                                                borderRadius: BorderRadius.all(
                                                  Radius.elliptical(
                                                    33,
                                                    33,
                                                  ),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                )
              : Container(),
          Positioned(
            top: 586 * verticalScale,
            left: 36 * horizontalScale,
            child: Text(
              'Explore more',
              textAlign: TextAlign.left,
              textScaleFactor: min(horizontalScale, verticalScale),
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontFamily: 'Poppins',
                fontSize: 24,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ),
          Positioned(
              top: 620 * verticalScale,
              child: Padding(
                padding: EdgeInsets.only(top: verticalScale * 8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: course.length,
                      itemBuilder: (BuildContext context, index) {
                        if (course[index].courseName == "null") {
                          return Container();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                courseId = course[index].courseDocumentId;
                              });

                              print(courseId);
                              if (course[index].isItComboCourse) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ComboStore(
                                      courses: course[index].courses,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CatelogueScreen(),
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.09,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  // height: MediaQuery.of(context).size.height * 0.16,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFE9E1FC),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //       color: Color.fromRGBO(
                                    //           29, 28, 30, 0.30000001192092896),
                                    //       offset: Offset(2, 2),
                                    //       // spreadRadius: 5,
                                    //       blurStyle: BlurStyle.outer,
                                    //       blurRadius: 35)
                                    // ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 100 *
                                              min(
                                                horizontalScale,
                                                verticalScale,
                                              ),
                                          width: 100 *
                                              min(
                                                horizontalScale,
                                                verticalScale,
                                              ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                course[index].courseImageUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            course[index].isItComboCourse
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        gradient: gradient),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        'COMBO',
                                                        textScaleFactor: min(
                                                          horizontalScale,
                                                          verticalScale,
                                                        ),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'SemiBold',
                                                            fontSize: 8,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            Container(
                                              // width: MediaQuery.of(context)
                                              //         .size
                                              //         .width *
                                              //     0.45,
                                              child: Text(
                                                course[index].courseName,
                                                textScaleFactor: min(
                                                  horizontalScale,
                                                  verticalScale,
                                                ),
                                                style: const TextStyle(
                                                  fontFamily: 'Bold',
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                // maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.45,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      course[index]
                                                          .courseLanguage,
                                                      textScaleFactor: min(
                                                        horizontalScale,
                                                        verticalScale,
                                                      ),
                                                      style: TextStyle(
                                                        fontFamily: 'Medium',
                                                        color: Colors.black
                                                            .withOpacity(0.4),
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Container(
                                                    child: Center(
                                                      child: Text(
                                                        '${course[index].numOfVideos} videos',
                                                        textScaleFactor: min(
                                                          horizontalScale,
                                                          verticalScale,
                                                        ),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Medium',
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7),
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 80,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              course[index].coursePrice,
                                              textScaleFactor: min(
                                                  horizontalScale,
                                                  verticalScale),
                                              style: TextStyle(
                                                fontFamily: 'Bold',
                                                color: Color(0xFF6E5BD9),
                                                fontSize: 17,
                                              ),
                                            ),
                                            // SizedBox(
                                            //   width: 40,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )),
          Positioned(
            top: 110 * verticalScale,
            left: 25 * horizontalScale,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_outlined,
                size: 40 * min(horizontalScale, verticalScale),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
