// import 'package:chat_new/screens/Authentication/methods.dart';
// import 'package:chat_new/screens/groups_list.dart';
// import 'package:chat_new/widgets/course_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CourseScreen extends StatefulWidget {
  // const CourseScreen({Key? key}) : super(key: key);

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  List? courseList = [];
  String message="";

  void loadCourses() async {
    setState(() {
      isLoading = true;
    });
    await _firestore.collection("Users")
    .where('id' , isEqualTo: _auth.currentUser!.uid )
    .orderBy('name')
    .get().then((value) {
      final courses = value.docs
          .map((doc) => {
                "id": doc.id,
                "data": doc.data(),
              })
          .toList();

      setState(() {
        courseList = courses;
      });
    });
    setState(() {
      isLoading = false;
    });
    print('courselist is--$courseList');
  }

  //  createGroup(Map<String, dynamic>? courseDetails) async {
  //   Map<String, dynamic> groupData = {
  //     "name": courseDetails!["data"]["paidCourseNames"],
  //     "icon": 'https://www.cloudyml.com/wp-content/uploads/2022/05/21421.jpg',
  //     // courseDetails["data"]["image_url"],
  //     "mentors": 'Rahul',
  //     // courseDetails["data"]["mentors"],
  //     "student_id": _auth.currentUser!.uid,
  //     "student_name": _auth.currentUser!.displayName,
  //   };

  //   Fluttertoast.showToast(msg: "Creating group...");

  //   await _firestore.collection("groups").add(groupData);

  //   Fluttertoast.showToast(msg: "Group Created");
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
       
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: courseList!.length,
              itemBuilder: (context, index) {
                // return createGroup(courseList![index]);
                
                // ElevatedButton(onPressed: onPressed, child: child)
                
               return  Text('Click me');
              },
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       CupertinoPageRoute(
      //         builder: (_) => GroupsList(),
      //       ),
      //     );
      //   },
      //   child: Icon(Icons.group),
      // ),
    );
  }
}