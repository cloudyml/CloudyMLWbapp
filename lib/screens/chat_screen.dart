import 'dart:async';
import 'package:cloudyml_app2/fun.dart';
import 'package:cloudyml_app2/screens/group_info.dart';
import 'package:cloudyml_app2/widgets/audio_msg_tile.dart';
import 'package:cloudyml_app2/widgets/bottom_sheet.dart';
import 'package:cloudyml_app2/widgets/file_msg_tile.dart';
import 'package:cloudyml_app2/widgets/image_msg_tile.dart';
import 'package:cloudyml_app2/widgets/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:image_picker/image_picker.dart";
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:badges/badges.dart';
import 'package:lottie/lottie.dart';
import '../widgets/assignment_bottomsheet.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  final groupData;
  final userData;
  String? groupId;

  ChatScreen({
    this.groupData,
    this.groupId,
    this.userData,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
//....................VARIABLES.................................
  TextEditingController _message = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? pickedFile;

  String? pickedFileName;

  String appStorage = "temp";

  int count = 0;

  ScrollController _scrollController = ScrollController();

  final StreamController<List<DocumentSnapshot>> _chatController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  List<List<DocumentSnapshot>> _allPagedResults = [<DocumentSnapshot>[]];

  static const int chatLimit = 10;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  Stream<List<DocumentSnapshot>> listenToChatsRealTime() {
    _getChats();
    return _chatController.stream;
  }

  bool textFocusCheck = false;

  Record record = Record();
  bool isRecording = false;
  bool _showbadge = false;

//...............FUNCTIONS.........................

  //getting chats with pagination logic

  //Global variables to hold tagImage and tagName of tag
  List<String> tagImages = [];
  List<String> tagNames = [];


  ///This mehtod adds Images and Names to be used for to [tagNames] and [tagImages]
  ///Group members for UI of list of tags
  Future<void> addTagProperties() async {
    //Take list User id of all mentors
    List tagUserId = widget.groupData['data']['mentors'];
    //Take user id of student
    tagUserId.add(widget.groupData['data']['student_id']);
    //Loop over list of member ids in tagUserId to fetch Name and Image of Respective member
    for (var member in tagUserId) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(member)
          .get()
          .then((value) {
        if (value.data() != null) {
          //Add member name and image to [tagNames] and [tagImages] only if does not contain already and
          //Only If member is not currentUser in FirebaseAuth
          if (!tagNames.contains(value.data()!['name']) &&
              value.data()!['name'] != widget.userData["name"]) {
            tagNames.add(value.data()!['name']);
            tagImages.add(value.data()!['image']);
          }
        }
      });
    }
  }

  //Flag used to make the list of tags visible and invisible
  bool shouldShowTags = false;

  ///This method inserts a text into textfield and moves cursor at end
  void _insertText(String inserted) {
    final text = _message.text;
    final selection = _message.selection;
    final newText = text.replaceRange(selection.start, selection.end, inserted);
    _message.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.baseOffset + inserted.length,
      ),
    );
  }

  ///This method returns widget that represents list of tags to choose from
  Widget buildTags(BuildContext context, double height, double width) {
    return Container(
      height: height * 0.25,
      width: width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border.all(
          color: Colors.grey,
          width: 0.1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          itemCount: tagNames.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/user.jpg'),
                foregroundImage: NetworkImage(tagImages[index]),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(tagNames[index]), Divider()],
              ),
              minVerticalPadding: 0,
              onTap: () {
                //If tapped on particular [listTile] it inserts tag of that member in textField
                _insertText('${tagNames[index]} ');
                //And Hides the list of tags
                setState(() {
                  currentTag = '@${tagNames[index]}';
                  shouldShowTags = false;
                });
              },
            );
          },
        ),
      ),
    );
  }

  String currentTag = '';

  void _getChats() {
    count = 0;
    var pageChatQuery = _firestore
        .collection("groups")
        .doc(widget.groupData!["id"])
        .collection("chats")
        .orderBy("time", descending: true)
        .limit(chatLimit);

    if (_lastDocument != null) {
      pageChatQuery = pageChatQuery.startAfterDocument(_lastDocument!);
    }

    if (!_hasMoreData) return;

    var currentRequestIndex = _allPagedResults.length;
    pageChatQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var generalChats = snapshot.docs.toList();
          var pageExists = currentRequestIndex < _allPagedResults.length;

          if (pageExists) {
            _allPagedResults[currentRequestIndex] = generalChats;
          } else {
            _allPagedResults.add(generalChats);
          }

          var allChats = _allPagedResults.fold<List<DocumentSnapshot>>(
              <DocumentSnapshot>[],
              (initialValue, pageItems) => initialValue..addAll(pageItems));

          _chatController.add(allChats);

          if (currentRequestIndex == _allPagedResults.length - 1) {
            _lastDocument = snapshot.docs.last;
          }

          _hasMoreData = generalChats.length == chatLimit;
        }
      },
    );
  }

  //image picker from camera logic
  Future getImage() async {
    FilePickerCross result = await FilePickerCross.importFromStorage(
        type: FileTypeCross.any,
        fileExtension: 'jpg, jpeg, png, bmp, svg'
    );
    if (result != null) {
      pickedFile = new File(result.path!!);
      pickedFileName = result.fileName;
      uploadFile("image");
    }
  }

  //file picker logic
  Future getFile() async {
    FilePickerCross result = await FilePickerCross.importFromStorage(
        type: FileTypeCross.any,
        fileExtension: 'txt, md'
    );
    if (result != null) {
      pickedFile = new File(result.path!!);
      pickedFileName = result.fileName;
      result.saveToPath(path: "/rajesh/files/"+result.fileName.toString());
      String? pathForExports = await result.exportToStorage();
      uploadFile("file");
    }
  }

  //storing file/image to firestore database
  Future uploadFile(type) async {
    try {
      var sentData = await _firestore
          .collection("groups")
          .doc(widget.groupData!["id"])
          .collection("chats")
          .add({
        "link": "",
        "message": pickedFileName,
        "sendBy": widget.userData["name"],
        "time": FieldValue.serverTimestamp(),
        "type": type == "image"
            ? "image"
            : type == "audio"
                ? "audio"
                : "file",
      });
      var fbstorage = FirebaseStorage.instance
          .ref()
          .child(type == "image"
              ? "images"
              : type == "audio"
                  ? "aduios"
                  : "files")
          .child(pickedFileName!);
      //To bring latest msg on top
      // await _firestore.collection('groups').doc(widget.groupData!["id"]).update(
      //   {'time': FieldValue.serverTimestamp()},
      // );

      var uploadTask = await fbstorage.putFile(pickedFile!);

      String fileUrl = await uploadTask.ref.getDownloadURL();

      await sentData.update({"link": fileUrl});
    } catch (e) {
      print("****** $e *****");
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  //storing message to firestore database
  void onSendMessage() async {
    //to send the text to server
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> message = {
        "message": _message.text,
        "sendBy": widget.userData["name"],
        "type": "text",
        "time": FieldValue.serverTimestamp(),
        "role": widget.userData["role"],
      };

      await _firestore
          .collection("groups")
          .doc(widget.groupData!["id"])
          .collection("chats")
          .add(message);

      print('count is-------$count');
      _message.clear();
      setState(() {
        textFocusCheck = false;
      });
    }
  }

  void startRecording() async {
    if (await Record().hasPermission()) {
      isRecording = true;
      await record.start(
        path: appStorage +
            "/audio_${DateTime.now().millisecondsSinceEpoch}.m4a",
        encoder: AudioEncoder.AAC,
        bitRate: 128000,
        samplingRate: 44100,
      );
    }
  }

  //stop recording and send audio message to firestore database
  void stopRecording() async {
    if (isRecording) {
      var filePath = await Record().stop();
      print("The audio file path is $filePath");
      pickedFile = File(filePath!);
      pickedFileName = filePath.split("/").last;
      isRecording = false;
      uploadFile("audio");
    }
  }

  //stop recording and delete recorde file
  void cancelRecording() async {
    if (isRecording) {
      var filePath = await Record().stop();
      var recordedFile = File(filePath.toString());
      if (await recordedFile.exists()) {
        await recordedFile.delete();
      }
      isRecording = false;
    }
  }

  //on record show bottom modal and send audio message
  void onSendAudioMessage() async {
    final size = MediaQuery.of(context).size;
    startRecording();
    showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50),
          ),
        ),
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: StatefulBottomSheet(
              size: size,
              startRecording: startRecording,
              stopRecording: stopRecording,
              cancelRecording: cancelRecording,
            ),
          );
        });
  }

  //getting path to app's internal storage
  /*Future getStoragePath() async {
    var s;
    if (await Permission.storage.request().isGranted) {
      s = await getExternalStorageDirectory();
    }
    setState(() {
      appStorage = s;
    });
  }*/

  // void showTags() {
  //   _message.text;
  // }

  @override
  Future<void> initState() async {
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              (_scrollController.position.maxScrollExtent) &&
          !_scrollController.position.outOfRange) {
        _getChats();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    record.dispose();
    super.dispose();
  }

  Future<void> initFirebase()
  async {
    await Firebase.initializeApp(options: FirebaseOptions(
        apiKey: "AIzaSyBdAio1wI3RVwl32RoKE7F9GNG_oWBpfbM",
        appId: "1:67056708090:web:f4a43d6b987991016ddc43",
        messagingSenderId: "67056708090",
        projectId: "cloudyml-app",
        databaseURL: "https://cloudyml-app-default-rtdb.firebaseio.com",
        authDomain: "cloudyml-app.firebaseapp.com",
        storageBucket: "cloudyml-app.appspot.com",
        measurementId: "G-PDLLH7550S"));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    print("user name is ${widget.userData["name"]}");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF7860DC),
            //     gradient: LinearGradient(
            // begin: Alignment.bottomLeft,
            // end: Alignment.topRight,
            // colors: [Color(0xFF7860DC),Color(0xFF7860DC)]),
          ),
        ),

        // backgroundColor: Colors.purple[800],
        elevation: 0,
        title: Container(
          padding: EdgeInsets.only(left: 0),
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.arrow_back),
                  )),
              CircleAvatar(
                radius: 22,
                backgroundImage:
                    NetworkImage(widget.groupData!["data"]["icon"]),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: width * 0.52,
                          child: Text(
                            widget.groupData!["data"]["name"],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // actions: [
        //   PopupMenuButton(
        //     itemBuilder: (context) {
        //       return [
        //         PopupMenuItem<int>(
        //           value: 0,
        //           child: Container(
        //             width: width * 0.5,
        //             child: const Text("Group Info"),
        //           ),
        //         ),
        //       ];
        //     },
        //     onSelected: (value) {
        //       if (value == 0) {
        //         print(widget.groupData);
        //         Navigator.push(
        //           context,
        //           CupertinoPageRoute(
        //             builder: (_) =>
        //                 GroupInfoScreen(groupData: widget.groupData!),
        //           ),
        //         );
        //       }
        //     },
        //   )
        // ],
      ),
      body: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  //Chats container
                  Container(
                    height: size.height / 1.33,
                    width: size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/g8.png'),
                          opacity: 0.16,
                          fit: BoxFit.cover),
                    ),
                    child: StreamBuilder<List<DocumentSnapshot>>(
                      stream: listenToChatsRealTime(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.connectionState == ConnectionState.none) {
                          return snapshot.hasData
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 5, 5, 5),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,

                                          //DecorationImage
                                          // border: Border.all(
                                          //   // color: Colors.green,
                                          //   width: 8,
                                          // ), //Border.all
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              offset: const Offset(
                                                1.0,
                                                1.0,
                                              ), //Offset
                                              blurRadius: 2.0,
                                              spreadRadius: 2.0,
                                            ), //BoxShadow
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              offset: const Offset(0.0, 0.0),
                                              blurRadius: 0.0,
                                              spreadRadius: 0.0,
                                            ), //BoxShadow
                                          ],
                                        ),
                                        margin:
                                            EdgeInsets.fromLTRB(25, 0, 25, 0),
                                        child: chat()
                                        //  Text(
                                        // 'You can ask assignment related doubts here 6pm- midnight.(Indian standard time)\nour mentors:-\n6:00pm-7:30pm - Rahul\n7:30pm-midnight - Harsh'),
                                        )
                                    // Center(
                                    //     child: Text("Start a Conversation."),
                                    //   ),
                                  ],
                                );
                        } else {
                          if (snapshot.data != null) {
                            return Stack(
                              children: [
                                ListView.builder(
                                  reverse: true,
                                  controller: _scrollController,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> map =
                                        // messageData =
                                        snapshot.data![index].data()
                                            as Map<String, dynamic>;

                                    return messages(
                                      size,
                                      map,
                                      context,
                                      appStorage,
                                      currentTag,
                                    );
                                  },
                                ),
                                shouldShowTags
                                    ? Positioned(
                                        bottom: 0,
                                        child: FutureBuilder(
                                          future: addTagProperties(),
                                          builder: ((context, snapshot) {
                                            if (ConnectionState.done ==
                                                snapshot.connectionState) {
                                              return buildTags(
                                                context,
                                                height,
                                                width,
                                              );
                                            } else {
                                              return Container(
                                                height: height * 0.25,
                                                width: width * 0.8,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                  ),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 0.1,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Lottie.asset(
                                                        'assets/load-shimmer.json',
                                                        fit: BoxFit.fill),
                                                  ),
                                                ),
                                              );
                                            }
                                          }),
                                        ),
                                      )
                                    : Container(),
                                // Positioned(
                                //   bottom: 0,
                                //   left: 0,
                                //   right: 0,
                                //   child: selectTags(context),
                                // )
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }
                      },
                    ),
                  ),
                  //Message Text Field container
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                  //   height: size.height *.098,
                  //   width: size.width * 1.2,
                  //   alignment: Alignment.bottomCenter,
                    // child:
                     Container(
                      alignment: Alignment.bottomCenter,
                      height: size.height *.1,
                      width: size.width /1.1,
                      child: 
                      Row(
                        children: [
                        Container(
                          margin:EdgeInsets.fromLTRB(0, 8, 0, 0),
                          height: height *.09 ,
                          width: size.width / 1.33,
                          child: TextField(
                            style: TextStyle(fontSize: 11),
                            // style: TextStyle(
                            //   color: _message.text.startsWith('@')
                            //       // &&
                            //       //         _message.text.endsWith('other')
                            //       ? Colors.green
                            //       : Colors.black,
                            // ),
                            onChanged: (text) {
                              setState(() {
                                if (text.contains('@')) {
                                  shouldShowTags = true;
                                } else {
                                  shouldShowTags = false;
                                }
                                if (text.isNotEmpty) {
                                  textFocusCheck = true;
                                } else {
                                  textFocusCheck = false;
                                }
                              });
                            },
                            // keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: _message,
                            autocorrect: true,
                            cursorColor: Colors.purple,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(10, 4, 0, 5),
                              // all(4),
                              suffixIcon: Container(
                                width: width * 0.23,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 27,
                                      child: IconButton(
                                        onPressed: () => getFile(),
                                        icon: const Icon(
                                          Icons.attach_file,
                                          color: Color(0xFF7860DC),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.photo),
                                      onPressed: () => getImage(),
                                      color: Color(0xFF7860DC),
                                    ),
                                  ],
                                ),
                              ),
                              fillColor: const Color.fromARGB(255, 119, 5, 181),
                              focusedBorder: OutlineInputBorder(
                               
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 35, 6, 194),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintText: "Ask Your Doubt...",
                              hintStyle: TextStyle(
                                
                                  fontSize: 13.0,
                                  color: Color.fromARGB(255, 183, 183, 183)),
                              border: OutlineInputBorder(
                                gapPadding: 0.0,
                                borderRadius: BorderRadius.circular(
                                  (5),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Ink(
                            
                            decoration: ShapeDecoration(
                              color: Color(0xFF7860DC),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: IconButton(
                              focusColor: Colors.blue,
                              splashRadius: 30,
                              splashColor: Colors.blueGrey,
                              onPressed: () async {
                                textFocusCheck
                                    ? onSendMessage()
                                    : onSendAudioMessage();
                                //To bring latest msg on top
                                await _firestore
                                    .collection('groups')
                                    .doc(widget.groupData!["id"])
                                    .update({'time': DateTime.now()});
                              },
                              icon: textFocusCheck
                                  ? const Icon(Icons.send)
                                  : const Icon(Icons.mic),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  // ),
                ],
              ),
            ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context,
      String appStorage, String currentTag) {
    //help us to show the text and the image in perfect alignment
    return map['type'] == "text" //checks if our msg is text or image
        ? MessageTile(size, map, widget.userData["name"], currentTag)
        : map["type"] == "image"
            ? ImageMsgTile(
                map: map,
                displayName: widget.userData["name"],
                appStorage: appStorage)
            : map["type"] == "audio"
                ? Container(
                    child: AudioMsgTile(
                      size: size,
                      map: map,
                      displayName: widget.userData["name"],
                      appStorage: appStorage,
                    ),
                  )
                : FileMsgTile(
                    size: size,
                    map: map,
                    displayName: widget.userData["name"],
                    appStorage: appStorage,
                  );
  }
}
