import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";

class GroupTile extends StatefulWidget {
  Map<String, dynamic>? groupData;
  Map? userData;

  GroupTile({this.groupData, this.userData});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  String getDate(Timestamp time) {
    var date = new DateTime.fromMicrosecondsSinceEpoch(time as int);
    return date.toString();
  }

  List item = [];
  int index = 1;

  void getdata() async {
    var vari = await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupData!['id'])
        .collection('chats')
        .orderBy('time', descending: true)
        .limit(1)
        .get()
        .then((value) {
      final chat = value.docs
          .map((doc) => {
                "id": doc.id,
                "data": doc.data(),
              })
          .toList();

      // setState(() {
        // message = item.['message'];
        item = chat;
        print('the data is $item');
        // message=item.['data'].['message'];
      // });
    });
  }

  void initState() {
    // getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(widget.groupData!["data"]["icon"]),
        ),
        title: Text(
          widget.groupData!["data"]["name"],
          // overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: SizedBox(),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.userData!["role"] == "mentor"
                ? Text("Student: ${widget.groupData!["data"]["student_name"]}")
                : SizedBox(),
            // StreamBuilder(
            //   stream: FirebaseFirestore.instance
            //       .collection('groups')
            //       .doc(widget.groupData!['id'])
            //       .collection('chats')
            //       .snapshots(),
            //   builder: (context,
            //       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            //     if (snapshot.data != null) {
            //       print(snapshot.data?.docs.last.data()['message']);
            //       return Text(
            //         snapshot.data?.docs.last.data()['message'],
            //         // overflow: TextOverflow.ellipsis,
            //         style: const TextStyle(fontSize: 14),
            //       );
            //     } else {
            //       return SizedBox();
            //     }
            //   },
            // ),
          ],
        ),
      ),
      // elevation: 2,
      // child: Container(
      //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      //   child: Row(
      //     children: [
      //       CircleAvatar(
      //         radius: 22,
      //         backgroundImage: NetworkImage(widget.groupData!["data"]["icon"]),
      //       ),
      //       Container(
      //         padding: const EdgeInsets.all(10),
      //         width: width * 0.75,
      //         child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               widget.userData!["role"] == "mentor"
      //                   ? Text(
      //                       "Student: ${widget.groupData!["data"]["student_name"]}")
      //                   : Container(),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Container(
      //                     width: width * 0.50,
      //                     child: Text(
      //                       widget.groupData!["data"]["name"],
      //                       overflow: TextOverflow.ellipsis,
      //                       style: const TextStyle(
      //                           fontSize: 18, fontWeight: FontWeight.bold),
      //                     ),
      //                   ),

      //                   Text(
      //                     item.isEmpty ? " " :DateFormat('hh:mm a')
      //                         .format(item[0]['data']['time'].toDate())
      //                         .toLowerCase(),
      //                     style: TextStyle(
      //                       fontSize: 12,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //               const SizedBox(height: 5),
      //               Text(
      //                 item.isEmpty ? " " : item[0]['data']['message'],
      //                 overflow: TextOverflow.ellipsis,
      //                 style: const TextStyle(fontSize: 14),
      //               ),
      //             ]),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
