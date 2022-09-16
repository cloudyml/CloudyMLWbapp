import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/fun.dart';
import 'package:cloudyml_app2/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import '../Providers/UserProvider.dart';
import '../widgets/group_tile.dart';

class GroupsList extends StatefulWidget {
  @override
  State<GroupsList> createState() => _GroupsListState();
  static ValueNotifier<int> messageCount = ValueNotifier(0);
}

class _GroupsListState extends State<GroupsList> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ValueNotifier<bool> _gettingMoreGroupDetails = ValueNotifier(false);
  ValueNotifier<bool> _moreGroupDetailsAvailable = ValueNotifier(true);
  FirebaseAuth _auth = FirebaseAuth.instance;
  dynamic groupData;
  // dynamic userData;
  String? groupId;
  List<int> newchatcount = [];
  bool isLoading = false;
  int? count;
  List? groupsList = [];
  DateTime now = new DateTime.now();
  static const int documentLimit = 30;
  DocumentSnapshot<Map<String, dynamic>>? _lastDocument;
  ScrollController _scrollController = ScrollController();
  // ValueNotifier<int> studentCount = ValueNotifier(0);
  Map? userData = {};
  loadUserData() async {
    await _firestore
        .collection("Users")
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
      // print("user data-- ${value.data()}");
      setState(() {
        userData = value.data();
      });
    });
  }

  void _getGroupDetails() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        userData!['role'] == 'student'
            ? await _firestore
                .collection("groups")
                .where("student_id", isEqualTo: _auth.currentUser!.uid)
                // .orderBy('sr', descending: true)
                .limit(documentLimit)
                .get()
                .then((value) => value)
            : await _firestore
                .collection("groups")
                // .where("mentors", arrayContains: _auth.currentUser!.uid)
                .orderBy('time', descending: true)
                .limit(documentLimit)
                .get()
                .then((value) => value);
    groupsList = querySnapshot.docs
        .map((doc) => {
              "id": doc.id,
              "data": doc.data(),
            })
        .toList();
    // getchatcount(querySnapshot.docs
    //     .map((doc) => {
    //           "id": doc.id,
    //           "data": doc.data(),
    //         })
    //     .toList());
    _lastDocument = querySnapshot.docs.last;
    setState(() {
      isLoading = false;
    });
  }

  void _getMoreGroupDetails() async {
    if (_gettingMoreGroupDetails.value) {
      return;
    }
    if (!_moreGroupDetailsAvailable.value) {
      return;
    }
    _gettingMoreGroupDetails.value = true;
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        userData!['role'] == 'student'
            ? await _firestore
                .collection("groups")
                .where("student_id", isEqualTo: _auth.currentUser!.uid)
                .startAfterDocument(_lastDocument!)
                .limit(documentLimit)
                .get()
                .then((value) => value)
            : await _firestore
                .collection("groups")
                .orderBy('time', descending: true)
                .startAfterDocument(_lastDocument!)
                .limit(documentLimit)
                .get()
                .then((value) => value);
    final groupDetailsList = querySnapshot.docs
        .map((doc) => {
              "id": doc.id,
              "data": doc.data(),
            })
        .toList();

    if (!(groupsList!.contains(groupDetailsList[0]))) {
      groupsList?.addAll(groupDetailsList);
      // getchatcount(groupDetailsList);
    }
    _lastDocument = querySnapshot.docs.last;
    print(groupsList?.length);
    if (querySnapshot.docs.length < documentLimit) {
      _moreGroupDetailsAvailable.value = false;
    }
    _gettingMoreGroupDetails.value = false;
  }

  void getchatcount(List groupDetailsList) async {
    for (var group in groupDetailsList) {
      await _firestore
          .collection("groups")
          .doc(group['id'])
          .collection("chats")
          .where('sendBy', isNotEqualTo: userData!["name"])
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          newchatcount.add(value.docs.length);
        }
      });
    }
  }

  void onScrollListner() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;
    double delta = MediaQuery.of(context).size.height;
    if (maxScroll - currentScroll <= delta * 0.2) {
      _getMoreGroupDetails();
    }
  }

  @override
  void initState() {
    loadUserData();
    Future.delayed(Duration(milliseconds: 1000), () {
      _getGroupDetails();
      Future.delayed(Duration(milliseconds: 1000), () {
        // getchatcount();
      });
      _scrollController.addListener(() {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double delta = MediaQuery.of(context).size.height;
        if (maxScroll - currentScroll <= delta * 0.2) {
          _getMoreGroupDetails();
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF7860DC),
              // gradient: gradient
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            // height: MediaQuery.of(context).size.height*.1 ,
            padding: const EdgeInsets.only(left: 0),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .08),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    Row(
                      children: [
                        Text(
                          'Chat',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      userData!["role"] == "student"
                          ? "Groups For You"
                          : "Groups For Mentors",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .05),
              ],
            ),
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : groupsList == null || groupsList!.isEmpty
                  ? Center(
                      heightFactor: 15,
                      child: Text(
                          userData!["role"] == "student"
                              ? "No Groups To Show!\n(Buy Course To Get Mentor's Support)!"
                              : "No Groups To Show!",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey)),
                    )
                  : Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: _gettingMoreGroupDetails,
                        builder: (context, bool value, child) {
                          return Stack(
                            children: [
                              ListView.builder(
                                controller: _scrollController,
                                itemCount: groupsList?.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    style: ListTileStyle.drawer,
                                    onTap: () async {
                                      await _firestore
                                          .collection('groups')
                                          .doc(groupsList![index]['id'])
                                          .collection('chats')
                                          .where('sendBy',
                                              isNotEqualTo:
                                                  userprovider.userModel!.name)
                                          .get()
                                          .then((value) async {
                                        await _firestore
                                            .collection("groups")
                                            .doc(groupsList![index]['id'])
                                            .update({
                                          'groupChatCount.${_auth.currentUser!.uid}':
                                              value.docs.length
                                        });
                                      });
                                      // userprovider.userModel!.role == 'student'
                                      //     ? await _firestore
                                      //         .collection("groups")
                                      //         .doc(groupsList![index]['id'])
                                      //         .update({
                                      //         'studentCount':
                                      //             newchatcount.length ==
                                      //                     {index + 1}
                                      //                 ? newchatcount[index]
                                      //                 : 0
                                      //       })
                                      //     : await _firestore
                                      //         .collection("groups")
                                      //         .doc(groupsList![index]['id'])
                                      //         .update({
                                      //         'mentorsCount.${_auth.currentUser!.uid}':
                                      //             newchatcount.isNotEmpty
                                      //                 ? newchatcount[index]
                                      //                 : 0
                                      //       });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ChatScreen(
                                            groupData: groupsList![index],
                                            groupId: groupsList![index]["id"],
                                            userData: userData,
                                          ),
                                        ),
                                      );
                                    },
                                    leading: CircleAvatar(
                                      radius: 22,
                                      backgroundImage: NetworkImage(
                                          groupsList![index]['data']["icon"]),
                                    ),
                                    title: Text(
                                      groupsList![index]['data']["name"],
                                      // overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: SizedBox(
                                      height: 35,
                                      width: 70,
                                      child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection("groups")
                                            .doc(groupsList![index]['id'])
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<
                                                    DocumentSnapshot<
                                                        Map<String, dynamic>>>
                                                documentSnapshot) {
                                          return StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection("groups")
                                                .doc(groupsList![index]['id'])
                                                .collection('chats')
                                                .where('sendBy',
                                                    isNotEqualTo: userprovider
                                                        .userModel!.name)
                                                .snapshots(),
                                            builder: (
                                              BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot,
                                            ) {
                                              if (snapshot.data != null) {
                                                // ((userprovider.userModel!.role ==
                                                //         'student')
                                                //     ? (documentSnapshot.data!
                                                //                 .data()
                                                //             as Map<String, dynamic>)[
                                                //         'studentCount']
                                                //     : (documentSnapshot.data!
                                                //                     .data()
                                                //                 as Map<String,
                                                //                     dynamic>)[
                                                //             'mentorsCount']
                                                //         [_auth.currentUser!.uid])
                                                if (snapshot.data!.docs.length >
                                                    documentSnapshot.data!
                                                                .data()![
                                                            'groupChatCount'][
                                                        _auth.currentUser!
                                                            .uid]) {
                                                  return StreamBuilder(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('groups')
                                                          .doc(
                                                              groupsList![index]
                                                                  ['id'])
                                                          .collection('chats')
                                                          .orderBy(
                                                            'time',
                                                            descending: true,
                                                          )
                                                          .snapshots(),
                                                      builder: (context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot<
                                                                      Map<String,
                                                                          dynamic>>>
                                                              snap) {
                                                        return Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            snap.data!.docs
                                                                    .first
                                                                    .data()[
                                                                        'message']
                                                                    .toString()
                                                                    .contains(
                                                                        '@${_auth.currentUser!.displayName}')
                                                                ? Text(
                                                                    '@',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  )
                                                                : SizedBox(),
                                                            Card(
                                                              color: Colors
                                                                  .green
                                                                  .shade400,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  100,
                                                                ),
                                                              ),
                                                              child: SizedBox(
                                                                height: 35,
                                                                width: 30,
                                                                child: Center(
                                                                  child: Text(
                                                                    '${snapshot.data!.docs.length - documentSnapshot.data!.data()!['groupChatCount'][_auth.currentUser!.uid]}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                } else {
                                                  return SizedBox();
                                                }
                                              } else
                                                return SizedBox();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        userData!["role"] == "mentor"
                                            ? Text(
                                                "Student: ${groupsList![index]['data']["student_name"]}")
                                            : SizedBox(),
                                        StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('groups')
                                              .doc(groupsList![index]['id'])
                                              .collection('chats')
                                              .orderBy(
                                                'time',
                                                descending: true,
                                              )
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot<
                                                      QuerySnapshot<
                                                          Map<String, dynamic>>>
                                                  snapshot) {
                                            if (snapshot.data != null) {
                                              return Text(
                                                snapshot.data?.docs.first
                                                    .data()['message'],
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              return SizedBox();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              value
                                  ? Container(
                                      color: Color.fromARGB(113, 221, 210, 251),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF7860DC),
                                          backgroundColor: Color(0xFFC0AAF5),
                                        ),
                                      ),
                                    )
                                  : SizedBox()
                            ],
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
