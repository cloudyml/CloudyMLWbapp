import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _formIndex = 1;
  // bool isFirstTime = false;
  // List<DocumentSnapshot> datas =[];
  //
  // getData() async {
  //   if (!isFirstTime) {
  //     QuerySnapshot snap =
  //     await FirebaseFirestore.instance.collection("Notifications").get();
  //     setState(() {
  //       isFirstTime = true;
  //       datas.addAll(snap.docs);
  //     });
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   isFirstTime = false;
  // }

  void initState() {
    Provider.of<UserProvider>(context, listen: false).reloadUserModel();
    // getData();
    // print(datas);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;

    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        backgroundColor: HexColor('7A62DE'),
        body: Stack(children: [
          Column(
            children: [
              SizedBox(
                height: verticalScale * 150,
              ),
              Container(
                height: height - verticalScale * 150,
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        min(horizontalScale, verticalScale) * 25),
                    topRight: Radius.circular(
                        min(horizontalScale, verticalScale) * 25),
                  ),
                ),
              ),
            ],
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
          Positioned(
              top: 59 * verticalScale,
              left: 126 * horizontalScale,
              right: 130 * horizontalScale,
              child: Text(
                'Notifications',
                textScaleFactor: min(horizontalScale, verticalScale),
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: verticalScale * 126,
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _formIndex = 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: _formIndex == 1
                                ? HexColor('6153D3')
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    min(horizontalScale, verticalScale) * 5)),
                          ),
                          child: Text(
                            'Users Notifications',
                            textScaleFactor:
                                min(horizontalScale, verticalScale),
                            style: TextStyle(
                              color: _formIndex == 1
                                  ? Colors.white
                                  : HexColor('6153D3'),
                              fontSize: 18,
                            ),
                          )),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _formIndex = 2;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: _formIndex == 2
                                ? HexColor('6153D3')
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    min(horizontalScale, verticalScale) * 5)),
                          ),
                          child: Text(
                            'App Notification',
                            textScaleFactor:
                                min(horizontalScale, verticalScale),
                            style: TextStyle(
                              color: _formIndex == 2
                                  ? Colors.white
                                  : HexColor('6153D3'),
                              fontSize: 18,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: (_formIndex == 1)
                      ? (userProvider.userModel?.userNotificationList!.length ==
                              0)
                          ? Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  height: 220 * verticalScale,
                                ),
                                Icon(
                                  Icons.notifications_none,
                                  size: 100,
                                ),
                                Text(
                                  'No Notifications yet',
                                  textScaleFactor:
                                      min(horizontalScale, verticalScale),
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'When you get notifications,they will show up here',
                                  textAlign: TextAlign.center,
                                  textScaleFactor:
                                      min(horizontalScale, verticalScale),
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            )
                          : MediaQuery.removePadding(
                              context: context,
                              removeBottom: true,
                              removeLeft: true,
                              removeRight: true,
                              removeTop: true,
                              child: ListView.builder(
                                  itemCount: userProvider
                                      .userModel?.userNotificationList!.length,
                                  itemBuilder: (_, index) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 10 * verticalScale,
                                        ),
                                        ListTile(
                                          title: Text(
                                            userProvider
                                                    .userModel
                                                    ?.userNotificationList![
                                                        index]
                                                    .title ??
                                                '',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                userProvider
                                                        .userModel
                                                        ?.userNotificationList![
                                                            index]
                                                        .body ??
                                                    '',
                                                style: TextStyle(
                                                    color: HexColor('464646')),
                                              ),
                                              Text(
                                                userProvider
                                                        .userModel
                                                        ?.userNotificationList![
                                                            index]
                                                        .NDate ??
                                                    '',
                                                textScaleFactor: min(
                                                    horizontalScale,
                                                    verticalScale),
                                                style: TextStyle(
                                                    color: HexColor('A9A9A9'),
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          leading: Image.network(userProvider
                                                  .userModel
                                                  ?.userNotificationList![index]
                                                  .notifyImage ??
                                              ''),
                                          trailing: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: HexColor('#F13758'),
                                            ),
                                            onPressed: () {
                                              userProvider.removeFromNotificationP(
                                                  userNotificationModel:
                                                      userProvider.userModel
                                                              ?.userNotificationList![
                                                          index]);
                                              userProvider.reloadUserModel();
                                            },
                                          ),
                                        ),
                                        Divider(
                                          thickness: 2,
                                        )
                                      ],
                                    );
                                  }),
                            )
                      : StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Notifications")
                              .orderBy("index", descending: true)
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data != null) {
                              if (snapshot.data!.docs.length != 0) {
                                return ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> map =
                                          snapshot.data!.docs[index].data();
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 4 * verticalScale,
                                          ),
                                          ListTile(
                                            title: Text(
                                              map['title'] ?? '',
                                              textScaleFactor: min(
                                                  horizontalScale,
                                                  verticalScale),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  map['description'] ?? '',
                                                  style: TextStyle(
                                                    color: HexColor('464646'),
                                                  ),
                                                ),
                                                Text(
                                                  map['Ndate'] ?? '',
                                                  textScaleFactor: min(
                                                      horizontalScale,
                                                      verticalScale),
                                                  style: TextStyle(
                                                      color: HexColor('A9A9A9'),
                                                      fontSize: 12),
                                                )
                                              ],
                                            ),
                                            leading: Image.network(
                                                map['icon'] ?? ''),
                                          ),
                                          Divider(
                                            thickness: 2,
                                          )
                                        ],
                                      );
                                    });
                              } else {
                                return Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      height: 220 * verticalScale,
                                    ),
                                    Icon(
                                      Icons.notifications_none,
                                      size: 100,
                                    ),
                                    Text(
                                      'No Notifications yet',
                                      textScaleFactor:
                                          min(horizontalScale, verticalScale),
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'When you get notifications,they will show up here',
                                      textAlign: TextAlign.center,
                                      textScaleFactor:
                                          min(horizontalScale, verticalScale),
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    )
                                  ],
                                );
                              }
                            } else {
                              return Container();
                            }
                          }),
                ),
              )
            ],
          ),
        ]));
  }
}



// ListView.builder(
//   shrinkWrap: true,
//   itemCount: datas.length,
//   itemBuilder: (context, index) {
//     //print(datas[index]["index"]);
//     return ListTile(
//       title: Text('${datas[index]["title"]}'??''),
//         subtitle: Text('${datas[index]["description"]}'??''),
//         leading: Image.network('${datas[index]["icon"]}'??''),
//       //   trailing: IconButton(
//       //     icon: Icon(Icons.delete),
//       //     onPressed: (){
//       //       setState((){
//       //         datas.removeAt(index);
//       //       });
//       //     },
//       // )
//     );
//   },
// ),



//ListView.builder(
//     shrinkWrap: true,
//     itemCount: userProvider.userModel?.userNotificationList!.length,
//       itemBuilder: (_,index){
//           return Column(
//               children: [
//                 SizedBox(height: 10,),
//                 ListTile(
//                   title: Text(userProvider.userModel?.userNotificationList![index].title??''),
//                   subtitle: Text(userProvider.userModel?.userNotificationList![index].body??''),
//                   leading: Image.network(userProvider.userModel?.userNotificationList![index].notifyImage??''),
//                   trailing: IconButton(
//                     icon: Icon(Icons.delete,color: HexColor('#C70000'),),
//                     onPressed: (){
//                           userProvider.removeFromNotificationP(userNotificationModel: userProvider.userModel?.userNotificationList![index]);
//                           userProvider.reloadUserModel();
//                     },
//                   ),
//                 ),
//                 Divider(thickness: 2,)
//               ],
//             );
//       }
//   )

//Padding(
//   padding:  EdgeInsets.fromLTRB(horizontalScale*24,verticalScale*0,horizontalScale*24,verticalScale*0),
//   child: Container(
//     height: 100*verticalScale,
//     color: Colors.grey,
//     child: Row(
//       children: [
//         Container(
//           height: 100*verticalScale,
//           width: 120*horizontalScale,
//           child: Image.asset('assets/HomeImage.png',
//            ),
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Align(
//               //alignment: Alignment.,
//               child: Text('AWS Course',
//                 textScaleFactor: min(horizontalScale,verticalScale),
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//             Text('Check out the latest AWS Course',
//               textScaleFactor: min(horizontalScale,verticalScale),
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 9,
//               ),
//             ),
//             Text('27-07-2022',
//               textScaleFactor: min(horizontalScale,verticalScale),
//               style: TextStyle(
//                 fontSize: 7,
//               ),
//             )
//           ],
//         ),
//     IconButton(
//         icon: Icon(Icons.delete,color: HexColor('#C70000'),),
//         onPressed: (){
//               userProvider.removeFromNotificationP(userNotificationModel: userProvider.userModel?.userNotificationList![index]);
//               userProvider.reloadUserModel();
//         },
//       ),
//       ],
//     ),
//   ),
// );