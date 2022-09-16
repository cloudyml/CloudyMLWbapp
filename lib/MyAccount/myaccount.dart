import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/MyAccount/ChangePassword.dart';
import 'package:cloudyml_app2/MyAccount/EditProfile.dart';
import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/offline/offline_videos.dart';
import 'package:cloudyml_app2/pages/notificationpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

late DocumentSnapshot snapshot;

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  void initState() {
    Provider.of<UserProvider>(context, listen: false).reloadUserModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context);
    // userprovider.reloadUserModel();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 350 * verticalScale,
            width: width,
            decoration: BoxDecoration(
              color: HexColor('7A62DE'),
              borderRadius: BorderRadius.only(
                bottomLeft:
                    Radius.circular(min(horizontalScale, verticalScale) * 25),
                bottomRight:
                    Radius.circular(min(horizontalScale, verticalScale) * 25),
              ),
            ),
          ),
          Positioned(
            top: 46 * verticalScale,
            left: 28 * horizontalScale,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 36,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: verticalScale * 73,
                ),
                Container(
                  height: verticalScale * 106,
                  width: horizontalScale * 106,
                  child: CircleAvatar(
                    radius: min(horizontalScale, verticalScale) * 30.0,
                    backgroundImage: AssetImage('assets/user.jpg'),
                    foregroundImage:
                        NetworkImage(userprovider.userModel?.image ?? ''),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                SizedBox(
                  height: verticalScale * 15,
                ),
                Text(
                  userprovider.userModel?.name.toString() ?? '',
                  textScaleFactor: min(horizontalScale, verticalScale),
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SemiBold',
                  ),
                ),
                Text(
                  userprovider.userModel?.email.toString() ?? '',
                  textScaleFactor: min(horizontalScale, verticalScale),
                  style: TextStyle(
                      fontSize: 14, color: Colors.white, fontFamily: 'Medium'),
                ),
                SizedBox(
                  height: verticalScale * 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '+91 ',
                      textScaleFactor: min(horizontalScale, verticalScale),
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: 'Medium'),
                    ),
                    Text(
                      userprovider.userModel?.mobile.toString() ?? '',
                      textScaleFactor: min(horizontalScale, verticalScale),
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: 'Medium'),
                    ),
                  ],
                ),
                SizedBox(
                  height: verticalScale * 23,
                ),
                Container(
                  //color: Colors.green,
                  height: verticalScale * 505,
                  width: horizontalScale * 366,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfilePage()));
                          },
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  horizontalScale * 29,
                                  verticalScale * 29,
                                  horizontalScale * 18,
                                  verticalScale * 14),
                              child: Row(
                                children: [
                                  Container(
                                      height:
                                          min(horizontalScale, verticalScale) *
                                              42,
                                      width:
                                          min(horizontalScale, verticalScale) *
                                              42,
                                      decoration: BoxDecoration(
                                        color: HexColor('EBE9FE'),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(min(horizontalScale,
                                                    verticalScale) *
                                                8)),
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        color: HexColor('6153D3'),
                                      )),
                                  SizedBox(
                                    width: horizontalScale * 18,
                                  ),
                                  Text(
                                    'Edit profile',
                                    textScaleFactor:
                                        min(horizontalScale, verticalScale),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              horizontalScale * 30,
                              verticalScale * 0,
                              horizontalScale * 30,
                              verticalScale * 0),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                    height: 260 * verticalScale,
                                    width: width,
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          min(horizontalScale, verticalScale) *
                                              16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(min(
                                                    horizontalScale,
                                                    verticalScale) *
                                                14.0),
                                            child: Text(
                                              'Support',
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  color: HexColor('7A62DE'),
                                                  fontWeight: FontWeight.bold),
                                              textScaleFactor: min(
                                                  horizontalScale,
                                                  verticalScale),
                                            ),
                                          ),
                                          SizedBox(
                                            height: verticalScale * 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  String telephoneUrl =
                                                      'tel:8587911971';
                                                  if (await canLaunch(
                                                      telephoneUrl)) {
                                                    await launch(telephoneUrl);
                                                  } else {
                                                    throw 'Could not launch $telephoneUrl';
                                                  }
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(min(
                                                                horizontalScale,
                                                                verticalScale) *
                                                            10.0),
                                                  ),
                                                  child: Container(
                                                    width:
                                                        horizontalScale * 120,
                                                    child: Padding(
                                                      padding: EdgeInsets.all(min(
                                                              horizontalScale,
                                                              verticalScale) *
                                                          14.0),
                                                      child: Container(
                                                        child: Column(
                                                          children: [
                                                            Icon(
                                                              Icons.phone,
                                                              color: HexColor(
                                                                  '7A62DE'),
                                                              size: min(
                                                                      horizontalScale,
                                                                      verticalScale) *
                                                                  40,
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  verticalScale *
                                                                      12,
                                                            ),
                                                            Text(
                                                              'Call us',
                                                              textScaleFactor: min(
                                                                  horizontalScale,
                                                                  verticalScale),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 20),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  final Uri params = Uri(
                                                      scheme: 'mailto',
                                                      path: 'app.support@cloudyml.com',
                                                      query:
                                                          'subject=Query about App');
                                                  var mailurl =
                                                      params.toString();
                                                  if (await canLaunch(
                                                      mailurl)) {
                                                    await launch(mailurl);
                                                  } else {
                                                    throw 'Could not launch $mailurl';
                                                  }
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(min(
                                                                horizontalScale,
                                                                verticalScale) *
                                                            10.0),
                                                  ),
                                                  child: Container(
                                                    width: verticalScale * 120,
                                                    child: Padding(
                                                      padding: EdgeInsets.all(min(
                                                              horizontalScale,
                                                              verticalScale) *
                                                          14.0),
                                                      child: Container(
                                                        child: Column(
                                                          children: [
                                                            Icon(
                                                              Icons.mail,
                                                              color: HexColor(
                                                                  '7A62DE'),
                                                              size: min(
                                                                      horizontalScale,
                                                                      verticalScale) *
                                                                  40,
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  verticalScale *
                                                                      12,
                                                            ),
                                                            Text(
                                                              'Mail us',
                                                              textScaleFactor: min(
                                                                  horizontalScale,
                                                                  verticalScale),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 20),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ));
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            );
                          },
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  horizontalScale * 29,
                                  verticalScale * 24,
                                  horizontalScale * 18,
                                  verticalScale * 14),
                              child: Row(
                                children: [
                                  Container(
                                      height:
                                          min(horizontalScale, verticalScale) *
                                              42,
                                      width:
                                          min(horizontalScale, verticalScale) *
                                              42,
                                      decoration: BoxDecoration(
                                        color: HexColor('EBE9FE'),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(min(horizontalScale,
                                                    verticalScale) *
                                                8)),
                                      ),
                                      child: Icon(
                                        Icons.headset_mic,
                                        color: HexColor('6153D3'),
                                      )),
                                  SizedBox(
                                    width: horizontalScale * 18,
                                  ),
                                  Text(
                                    'Support',
                                    textScaleFactor:
                                        min(horizontalScale, verticalScale),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              horizontalScale * 30,
                              verticalScale * 0,
                              horizontalScale * 30,
                              verticalScale * 0),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OfflinePage()));
                          },
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  horizontalScale * 29,
                                  verticalScale * 23,
                                  horizontalScale * 18,
                                  verticalScale * 14),
                              child: Row(
                                children: [
                                  Container(
                                      height:
                                          min(horizontalScale, verticalScale) *
                                              42,
                                      width:
                                          min(horizontalScale, verticalScale) *
                                              42,
                                      decoration: BoxDecoration(
                                        color: HexColor('EBE9FE'),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(min(horizontalScale,
                                                    verticalScale) *
                                                8)),
                                      ),
                                      child: Icon(
                                        Icons.download,
                                        color: HexColor('6153D3'),
                                      )),
                                  SizedBox(
                                    width: horizontalScale * 18,
                                  ),
                                  Text(
                                    'Downloads',
                                    textScaleFactor:
                                        min(horizontalScale, verticalScale),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              horizontalScale * 30,
                              verticalScale * 0,
                              horizontalScale * 30,
                              verticalScale * 0),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotificationPage()));
                          },
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  horizontalScale * 29,
                                  verticalScale * 22,
                                  horizontalScale * 18,
                                  verticalScale * 14),
                              child: Row(
                                children: [
                                  Container(
                                      height:
                                          min(horizontalScale, verticalScale) *
                                              42,
                                      width:
                                          min(horizontalScale, verticalScale) *
                                              42,
                                      decoration: BoxDecoration(
                                        color: HexColor('EBE9FE'),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(min(horizontalScale,
                                                    verticalScale) *
                                                8)),
                                      ),
                                      child: Icon(
                                        Icons.notifications_active,
                                        color: HexColor('6153D3'),
                                      )),
                                  SizedBox(
                                    width: horizontalScale * 18,
                                  ),
                                  Text(
                                    'Notifications',
                                    textScaleFactor:
                                        min(horizontalScale, verticalScale),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              horizontalScale * 30,
                              verticalScale * 0,
                              horizontalScale * 30,
                              verticalScale * 0),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChangePassword()));
                          },
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  horizontalScale * 29,
                                  verticalScale * 25,
                                  horizontalScale * 18,
                                  verticalScale * 14),
                              child: Row(
                                children: [
                                  Container(
                                      height:
                                          min(horizontalScale, verticalScale) *
                                              42,
                                      width:
                                          min(horizontalScale, verticalScale) *
                                              42,
                                      decoration: BoxDecoration(
                                        color: HexColor('EBE9FE'),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(min(horizontalScale,
                                                    verticalScale) *
                                                8)),
                                      ),
                                      child: Icon(
                                        Icons.key,
                                        color: HexColor('6153D3'),
                                      )),
                                  SizedBox(
                                    width: horizontalScale * 18,
                                  ),
                                  Text(
                                    'Change Password',
                                    textScaleFactor:
                                        min(horizontalScale, verticalScale),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              horizontalScale * 30,
                              verticalScale * 0,
                              horizontalScale * 30,
                              verticalScale * 0),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            logOut(context);
                          },
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  horizontalScale * 29,
                                  verticalScale * 21,
                                  horizontalScale * 18,
                                  verticalScale * 14),
                              child: Row(
                                children: [
                                  Container(
                                      height:
                                          min(horizontalScale, verticalScale) *
                                              42,
                                      width:
                                          min(horizontalScale, verticalScale) *
                                              42,
                                      decoration: BoxDecoration(
                                        color: HexColor('EBE9FE'),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(min(horizontalScale,
                                                    verticalScale) *
                                                8)),
                                      ),
                                      child: Icon(
                                        Icons.logout,
                                        color: HexColor('6153D3'),
                                      )),
                                  SizedBox(
                                    width: horizontalScale * 18,
                                  ),
                                  Text(
                                    'LogOut',
                                    textScaleFactor:
                                        min(horizontalScale, verticalScale),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
