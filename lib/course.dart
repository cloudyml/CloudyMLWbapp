// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloudyml_app2/globals.dart';
// import 'package:cloudyml_app2/module/assignment_screen.dart';
// import 'package:cloudyml_app2/module/video_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';

// class Couse extends StatefulWidget {
//   const Couse({Key? key}) : super(key: key);

//   @override
//   State<Couse> createState() => _CouseState();
// }

// class _CouseState extends State<Couse> {
//   var amountcontroller = TextEditingController();
//   String? name = '';

//   void getCourseName() async {
//     await FirebaseFirestore.instance
//         .collection('courses')
//         .doc(courseId)
//         .get()
//         .then((value) {
//       setState(() {
//         name = value.data()!['name'];
//         print('ufbufb--$name');
//       });
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getCourseName();
//   }

//   int _counter = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Icon(
//               Icons.arrow_back,
//               color: Colors.black,
//             ),
//           ),
//           title: Text(
//             name!,
//             style: TextStyle(fontFamily: 'Bold', color: Colors.black),
//           )),
//       body: Padding(
//           padding: const EdgeInsets.only(top: 50.0, right: 10, left: 10),
//           child: Column(
//             children: [
//               Expanded(
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('courses')
//                       .doc(courseId)
//                       .collection('Modules')
//                       .snapshots(),
//                   builder: (BuildContext context,
//                       AsyncSnapshot<QuerySnapshot> snapshot) {
//                     if (!snapshot.hasData) return const SizedBox.shrink();
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: snapshot.data!.docs.length,
//                       itemBuilder: (BuildContext context, index) {
//                         DocumentSnapshot document = snapshot.data!.docs[index];
//                         Map<String, dynamic> map = snapshot.data!.docs[index]
//                             .data() as Map<String, dynamic>;
//                         if (map["name"].toString() == "null") {
//                           return Container();
//                         }

//                         return Padding(
//                           padding: const EdgeInsets.all(18.0),
//                           child: InkWell(
//                             onTap: () {
//                               print('working');
//                               if (map['firstType'] == 'video') {
//                                 Navigator.push(
//                                   context,
//                                   PageTransition(
//                                     duration: Duration(milliseconds: 400),
//                                     curve: Curves.bounceInOut,
                                    // type: PageTransitionType.topToBottom,
//                                     child: VideoScreen(
//                                       isdemo: false,
//                                       sr: 1,
//                                       courseName: name,
//                                     ),
//                                   ),
//                                 );
//                               } else if (map['firstType'] == 'assignment') {
//                                 Navigator.push(
//                                   context,
//                                   PageTransition(
//                                     duration: Duration(milliseconds: 400),
//                                     curve: Curves.bounceInOut,
//                                     type: PageTransitionType.topToBottom,
//                                     child: AssignmentScreen(
//                                       isdemo: false,
//                                       sr: 1,
//                                     ),
//                                   ),
//                                 );
//                               }
//                               // else {
//                               //   Navigator.push(
//                               //     context,
//                               //     PageTransition(
//                               //         duration: Duration(milliseconds: 400),
//                               //         curve: Curves.bounceInOut,
//                               //         type: PageTransitionType.topToBottom,
//                               //         child: QuizPage()),
//                               //   );
//                               // }

//                               setState(() {
//                                 moduleId = document.id;
//                               });
//                             },
//                             child: Container(
//                               alignment: Alignment.centerLeft,
//                               height: 100,
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: Colors.grey.shade100),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(18.0),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       map['name'],
//                                       style: TextStyle(
//                                           fontFamily: 'SemiBold',
//                                           fontSize: 18,
//                                           color: Colors.black),
//                                     ),
//                                     Icon(Icons.arrow_right)
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           )),
//     );
//   }
// }
