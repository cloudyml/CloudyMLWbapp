import 'dart:math';

import 'package:cloudyml_app2/payments_history.dart';
import 'package:cloudyml_app2/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:cloudyml_app2/models/firebase_file.dart';
import 'package:cloudyml_app2/screens/image_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cloudyml_app2/globals.dart';
import 'aboutus.dart';
import 'authentication/firebase_auth.dart';
import 'home.dart';
import 'my_Courses.dart';

Row Star() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Icon(
        Icons.star,
        color: Color.fromARGB(255, 6, 240, 185),
        size: 18,
      ),
      Icon(
        Icons.star,
        color: Color.fromARGB(255, 6, 240, 185),
        size: 18,
      ),
      Icon(
        Icons.star,
        color: Color.fromARGB(255, 6, 240, 185),
        size: 18,
      ),
      Icon(
        Icons.star,
        color: Color.fromARGB(255, 6, 240, 185),
        size: 18,
      ),
      Icon(
        Icons.star_half,
        color: Color.fromARGB(255, 6, 240, 185),
        size: 18,
      ),
    ],
  );
}

Widget buildFile(BuildContext context, FirebaseFile file) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ImagePage(file: file),
            ),
          ),
          child: solidBorder(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 8.0,
                    spreadRadius: .09,
                    offset: Offset(1, 5),
                  )
                ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    file.url,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

Widget featureTile(
    IconData icon, String T1, double horizontalScale, double verticalScale) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      width: 364 * horizontalScale,
      height: 38 * verticalScale,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(31, 31, 31, 0.25),
              offset: Offset(0, 0),
              blurRadius: 5)
        ],
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
      child: Row(
        children: [
          Container(
            width: 38 * min(horizontalScale, verticalScale),
            height: 38 * min(horizontalScale, verticalScale),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              color: Color.fromRGBO(122, 98, 222, 1),
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: 28 * min(horizontalScale, verticalScale),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            '$T1',
            textScaleFactor: min(horizontalScale, verticalScale),
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
  // return Padding(
  //   padding: const EdgeInsets.all(8.0),
  //   child: Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       Icon(
  //         Icn,
  //         color: Color(0xFF7860DC),
  //       ),
  //       SizedBox(
  //         width: 13,
  //       ),
  //       Text(
  //         '$T1',
  //         style: TextStyle(
  //           overflow: TextOverflow.ellipsis,
  //           color: Colors.black,
  //           fontSize: 13,
  //         ),
  //       ),
  //     ],
  //   ),
  // );
}

Column includes(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
  var verticalScale = screenHeight / mockUpHeight;
  var horizontalScale = screenWidth / mockUpWidth;
  return Column(
    children: [
      Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Course Features!',
            // textAlign: TextAlign.left,
            textScaleFactor: min(horizontalScale, verticalScale),
            style: TextStyle(
                color: Color.fromRGBO(48, 48, 49, 1),
                fontFamily: 'Poppins',
                fontSize: 20,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.bold,
                height: 1),
          ),
        ),
      ),
      SizedBox(
        height: 15,
      ),
      featureTile(
        Icons.book,
        'Guided Hands-On Assignment',
        horizontalScale,
        verticalScale,
      ),
      featureTile(
        Icons.assignment,
        'Capstone End to End Project',
        horizontalScale,
        verticalScale,
      ),
      featureTile(
        Icons.badge,
        'One Month Internship Opportunity',
        horizontalScale,
        verticalScale,
      ),
      featureTile(
        Icons.call,
        '1-1 Chat Support',
        horizontalScale,
        verticalScale,
      ),
      featureTile(
        Icons.email,
        'Job Referrals & Opening Mails',
        horizontalScale,
        verticalScale,
      ),
      featureTile(
        Icons.picture_as_pdf,
        'Interview Q&As PDF Collection',
        horizontalScale,
        verticalScale,
      ),
      featureTile(
        Icons.picture_in_picture,
        'Course Completion Certificates',
        horizontalScale,
        verticalScale,
      ),
    ],
  );
}

Row Buttoncombo(double width, String orgprice, String saleprice) {
  return Row(
    children: [
      Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
      Container(
        // height: 35,
        // width: width * .27,
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(20),
        //     color: Colors.grey.shade300),
        child: Center(
          child: Text(
            '₹$orgprice/-',
            style: TextStyle(
                fontFamily: 'bold',
                color: Colors.black,
                fontSize: 10,
                decoration: TextDecoration.lineThrough),
          ),
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Container(
        // height: 35,
        // width: width * .27,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(20),
        //   gradient: LinearGradient(
        //     begin: Alignment.bottomLeft,
        //     end: Alignment.topRight,
        //     colors: [Color(0xFF57ebde), Color(0xFFaefb2a)],
        //   ),
        // ),
        child: Center(
          child: Text(
            '₹$saleprice/-',
            style: TextStyle(
              fontFamily: 'bold',
              color: Colors.black,
              fontSize: 10,
            ),
          ),
        ),
      )
    ],
  );
}

Row Button1(
  double width,
  String orgprice,
) {
  return Row(
    children: [
      Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
      Container(
        // height: 35,
        // width: width * .27,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(20),
        //   gradient: LinearGradient(
        //     begin: Alignment.bottomLeft,
        //     end: Alignment.topRight,
        //     colors: [Color(0xFF57ebde), Color(0xFFaefb2a)],
        //   ),
        // ),
        child: Center(
          child: Text(
            '$orgprice',
            style: TextStyle(
              fontFamily: 'bold',
              color: Colors.black,
              fontSize: 10,
            ),
          ),
        ),
      )
    ],
  );
}

Container img(double width, double height, String link) {
  return Container(
    height: height * .25,
    width: width * 13,
    child: Image(image: NetworkImage(link), fit: BoxFit.fill),
  );
}

Column colname(String text1, String text2) {
  return Column(children: [
    Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.topLeft,
      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Text(
        '$text1',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Colors.black,
            fontSize: 11,
            fontFamily: 'GideonRoman',
            fontWeight: FontWeight.bold,
            height: .97),
      ),
    ),
    Container(
      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
      alignment: Alignment.topLeft,
      child: Text(
        '$text2',
        style: TextStyle(color: Colors.black, fontSize: 15),
      ),
    ),
  ]);
}

SafeArea safearea() {
  final image1 = imageFile('assets/image_1.jpeg');
  final image2 = imageFile('assets/image_2.jpeg');
  final image3 = imageFile('assets/image_3.jpeg');
  final image4 = imageFile('assets/image_4.jpeg');
  final image5 = imageFile('assets/image_5.jpeg');

  return
      // appBar: AppBar(),
      SafeArea(
          child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          const Text(
            'Recent Success Stories Of Our Learners',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          solidBorder(
            child: image1,
          ),
          const SizedBox(
            height: 15,
          ),
          solidBorder(
            child: image2,
          ),
          const SizedBox(
            height: 15,
          ),
          solidBorder(
            child: image3,
          ),
          const SizedBox(
            height: 15,
          ),
          solidBorder(
            child: image4,
          ),
          const SizedBox(
            height: 15,
          ),
          solidBorder(
            child: image5,
          ),
        ],
      ),
    ),
  ));
}

Widget solidBorder({required Widget child}) {
  return DottedBorder(
    strokeWidth: 5,
    padding: EdgeInsets.all(2),
    color: Colors.white24,
    borderType: BorderType.RRect,
    radius: const Radius.circular(20),
    dashPattern: const [1, 0],
    child: child,
  );
}

Widget imageFile(String url) {
  return Image.asset(
    url,
    width: 330,
    height: 330,
    fit: BoxFit.cover,
  );
}

SingleChildScrollView safearea1(BuildContext context) {
  // final size = MediaQuery.of(context).size;
  //   final height = size.height;
  //   final width = size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
  var verticalScale = screenHeight / mockUpHeight;
  var horizontalScale = screenWidth / mockUpWidth;
  final LinearGradient _gradient = const LinearGradient(
    colors: [Colors.white, Colors.white],
  );
  // print('i love you');
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // ShaderMask(
        //   shaderCallback: (Rect rect) {
        //     return _gradient.createShader(rect);
        //   },
        //   child:
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                    image: AssetImage('assets/a1.png'),
                    height: 225,
                    width: 350,
                    fit: BoxFit.fill),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
          child: Text(
            'About Me',
            textScaleFactor: min(horizontalScale, verticalScale),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 15, 0),
          child: Container(
            width: 300,
            alignment: Alignment.topLeft,
            child: const Text.rich(TextSpan(
                text: 'I have transitioned my career from ',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  wordSpacing: 1,
                ),
                children: [
                  TextSpan(
                      text: 'Manual Tester to Data Scientist ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 12,
                        wordSpacing: 5,
                      )),
                  TextSpan(
                    text:
                        'by upskilling myself on my own from various online resources and doing lots of ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      wordSpacing: 5,
                    ),
                  ),
                  TextSpan(
                      text: 'Hands-on practice. ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        wordSpacing: 5,
                      )),
                  TextSpan(
                      text: 'For internal switch I sent around ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        wordSpacing: 2,
                      )),
                  TextSpan(
                    text: '150 mails ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 5,
                    ),
                  ),
                  TextSpan(
                      text: 'to different project managers, ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        wordSpacing: 5,
                      )),
                  TextSpan(
                      text: 'interviewed in 20 ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 5,
                      )),
                  TextSpan(
                      text: 'and got selected in ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        wordSpacing: 4,
                      )),
                  TextSpan(
                      text: '10 projects.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        wordSpacing: 5,
                      )),
                ])),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Container(
            width: 300,
            child: const Text.rich(TextSpan(
                text:
                    'When it came to changing company I put papers with NO offers in hand. And in the notice period I struggled to get a job. First 2 months were very difficult but in the last month things started changing miraculously.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  wordSpacing: 3,
                ))),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Container(
            width: 340,
            child: const Text.rich(TextSpan(
              text: 'I attended ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                wordSpacing: 5,
              ),
              children: [
                TextSpan(
                    text: '40+ interviews ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 5,
                    )),
                TextSpan(
                    text: 'in span of ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      wordSpacing: 5,
                    )),
                TextSpan(
                    text: '3 months ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 5,
                    )),
                TextSpan(
                    text: 'with the help of ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      wordSpacing: 5,
                    )),
                TextSpan(
                    text: 'Naukri and LinkedIn profile Optimizations ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 5,
                    )),
                TextSpan(
                    text: 'and got offer by ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      wordSpacing: 5,
                    )),
                TextSpan(
                    text: '8 companies. ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 5,
                    )),
              ],
            )),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    ),
  );
}

Drawer dr(BuildContext context) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  return Drawer(
    child: ListView(
      padding: EdgeInsets.only(top: 0),
      children: [
        Container(
            height: height * 0.27,
            //decoration: BoxDecoration(gradient: gradient),
            color: HexColor('7B62DF'),
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("Users").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> map = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    if (map["id"].toString() ==
                        FirebaseAuth.instance.currentUser!.uid) {
                      return Padding(
                        padding: EdgeInsets.all(width * 0.05),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: width * 0.089,
                                backgroundImage: AssetImage('assets/user.jpg'),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              map['name'] != null
                                  ? Text(
                                      map['name'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: width * 0.049),
                                    )
                                  : Text(
                                      map['mobilenumber'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: width * 0.049),
                                    ),
                              SizedBox(
                                height: height * 0.007,
                              ),
                              map['email'] != null
                                  ? Text(
                                      map['email'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width * 0.038),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              },
            )),
        InkWell(
          child: ListTile(
            title: Text('Home'),
            leading: Icon(
              Icons.home,
              color: HexColor('6153D3'),
            ),
          ),
          onTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        // InkWell(
        //   child: ListTile(
        //     title: Text('My Account'),
        //     leading: Icon(
        //       Icons.person,
        //       color: HexColor('6153D3'),
        //     ),
        //   ),
        // ),
        InkWell(
          child: ListTile(
            title: Text('My Courses'),
            leading: Icon(
              Icons.book,
              color: HexColor('6153D3'),
            ),
          ),
          onTap: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PaymentHistory()));
          },
          child: ListTile(
            title: Text('Payment History'),
            leading: Icon(
              Icons.payment_rounded,
              color: HexColor('6153D3'),
            ),
          ),
        ),
        Divider(
          thickness: 2,
        ),
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PrivacyPolicy()));
          },
          child: ListTile(
            title: Text('Privacy policy'),
            leading: Icon(
              Icons.privacy_tip,
              color: HexColor('6153D3'),
            ),
          ),
        ),
        InkWell(
          child: ListTile(
            title: Text('About Us'),
            leading: Icon(
              Icons.info,
              color: HexColor('6153D3'),
            ),
          ),
          onTap: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AboutUs()));
          },
        ),
        InkWell(
          child: ListTile(
            title: Text('LogOut'),
            leading: Icon(
              Icons.logout,
              color: HexColor('6153D3'),
            ),
          ),
          onTap: () {
            logOut(context);
          },
        ),
      ],
    ),
  );
}

Column chat(){
  return Column(
    children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 15, 10),
          child: Container(
            width: 300,
            alignment: Alignment.topLeft,
            child: const Text.rich(TextSpan(
                text: 'You can ask assignment related doubts here 6pm- midnight.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  wordSpacing: 1,
                ),
                children: [
                  TextSpan(
                      text: '(Indian standard time)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 12,
                        wordSpacing: 5,
                      )),
                  TextSpan(
                    text:
                        '\nOur mentors:-',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      wordSpacing: 5,
                    ),
                  ),
                 
                  TextSpan(
                      text: '\n6:00pm-7:30pm - Rahul',
                      style: TextStyle(
                        fontSize: 12,
                        height: 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        wordSpacing: 5,
                      )),
                  TextSpan(
                      text: '\n7:30pm-midnight - Harsh',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        wordSpacing: 2,
                      )),
                  TextSpan(
                    text: '\nPowerbi doubt - 11am-12 afternoon',
                    style: TextStyle(
                      color: Colors.black,
                      height: 2,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 5,
                    ),
                  ),
                  TextSpan(
                      text: '\nHow can you learn better?\n -Its a good idea to google once about your doubt and see what stackoverflow suggest and how others solved the same kind of doubt by looking at documentation once.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        wordSpacing: 5,
                      )),
                  // TextSpan(
                  //     text: '\nNote : ',
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       height: 2,
                  //       color: Colors.black,
                  //       fontWeight: FontWeight.bold,
                  //       wordSpacing: 5,
                  //     )),
                  // TextSpan(
                  //     text: '\n1) If you see late response from mentor multiple times',
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       color: Colors.black,
                  //       wordSpacing: 4,
                  //     )),
                  // TextSpan(
                  //     text: 'during 6pm - midnight (more than 5 minutes or max more than 10 minutes )',
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.black,
                  //       wordSpacing: 5,
                  //     )),
                  //     TextSpan(
                  //     text: ' then tag me and raise the concern.',
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       color: Colors.black,
                  //       wordSpacing: 4,
                  //     )),
                  //     TextSpan(
                  //     text: '\n2) Assignments are self evaluated. After submission, theres a solution link provided, go through it and self evaluate.',
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       color: Colors.black,
                  //       wordSpacing: 4,
                  //     )),
                ])),
          ),
        ),
    ],
  );
}
