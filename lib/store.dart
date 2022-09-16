import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/catalogue_screen.dart';
import 'package:cloudyml_app2/combo/combo_store.dart';
import 'package:cloudyml_app2/fun.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:cloudyml_app2/models/course_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
    return Scaffold(
      key: _scaffoldKey,
      // drawer: dr(context),
      body: Container(
        color: Colors.deepPurple,
        child: Stack(children: [
          Positioned(
            // left: -50,
            // width: 100,
            // height: 100,
            top: -98.00000762939453,
            left: -88.00000762939453,
            // child: CircleAvatar(
            //   radius: 70,
            //   backgroundColor: Color.fromARGB(255, 173, 149, 149),
            // ),
            child: Container(
                width: 161.99998474121094,
                height: 161.99998474121094,
                decoration: BoxDecoration(
                  color: Color.fromARGB(55, 126, 106, 228),
                  borderRadius: BorderRadius.all(Radius.elliptical(
                      161.99998474121094, 161.99998474121094)),
                )),
          ),
          Positioned(
            // right: MediaQuery.of(context).size.width * (-.16),
            // bottom: MediaQuery.of(context).size.height * .7,
            top: 73.00000762939453,
            left: 309,

            // child: CircleAvatar(
            //   radius: 80,
            //   backgroundColor: Color.fromARGB(255, 173, 149, 149),
            // ),
            child: Container(
                width: 161.99998474121094,
                height: 161.99998474121094,
                decoration: BoxDecoration(
                  color: Color.fromARGB(55, 126, 106, 228),
                  borderRadius: BorderRadius.all(Radius.elliptical(
                      161.99998474121094, 161.99998474121094)),
                )),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            //color: Color.fromARGB(214, 83, 109, 254),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                          // Scaffold.of(context).openDrawer();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.17,
                      ),
                      Text(
                        'Store',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                        color: Colors.white),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent:
                                      MediaQuery.of(context).size.width * .5,
                                  childAspectRatio: .68),
                          itemCount: course.length,
                          itemBuilder: (context, index) {
                            return InkWell(
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
                                            const CatelogueScreen()),
                                  );
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Color.fromARGB(192, 255, 255, 255),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(
                                          168, 133, 250, 0.7099999785423279),
                                      offset: Offset(2, 2),
                                      blurRadius: 5,
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(08.0),
                                  child: Column(
                                    //mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Container(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              course[index].courseImageUrl,
                                              fit: BoxFit.cover,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .15,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .4,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .06,
                                        child: Text(
                                          course[index].courseName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .035),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .004,
                                      ),
                                      Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment
                                        //         .center,
                                        children: [
                                          Text(
                                            course[index].courseLanguage,
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .03),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .02,
                                          ),
                                          Text(
                                            '||',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .03),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .02,
                                          ),
                                          Text(
                                            course[index].numOfVideos,
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .03),
                                          ),
                                          // const SizedBox(
                                          //   height: 10,
                                          // ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .015,
                                      ),
                                      // Row(
                                      //   children: [
                                      //     Container(
                                      //       width:
                                      //           MediaQuery.of(context)
                                      //                   .size
                                      //                   .width *
                                      //               0.20,
                                      //       height:
                                      //           MediaQuery.of(context)
                                      //                   .size
                                      //                   .height *
                                      //               0.030,
                                      //       decoration: BoxDecoration(
                                      //           borderRadius:
                                      //               BorderRadius
                                      //                   .circular(10),
                                      //           color: Colors.green),
                                      //       child: const Center(
                                      //         child: Text(
                                      //           'ENROLL NOW',
                                      //           style: TextStyle(
                                      //               fontSize: 10,
                                      //               color:
                                      //                   Colors.white),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     const SizedBox(
                                      //       width: 15,
                                      //     ),
                                      //     Text(
                                      //       map['Course Price'],
                                      //       style: const TextStyle(
                                      //         fontSize: 13,
                                      //         color: Colors.indigo,
                                      //         fontWeight:
                                      //             FontWeight.bold,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      Row(
                                        children: [
                                          // SizedBox(
                                          //     width: MediaQuery.of(
                                          //         context)
                                          //         .size
                                          //         .width *
                                          //         .23),
                                          Text(
                                            course[index].coursePrice,
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .03,
                                              color: Colors.indigo,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
