import 'package:flutter/material.dart';

class GroupInfoScreen extends StatefulWidget {
  final groupData;

  GroupInfoScreen({this.groupData});

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Info'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 25),
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: size.width * 0.25,
                backgroundImage: NetworkImage(
                  widget.groupData!["data"]["icon"],
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.groupData!["data"]["name"],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //  Container(
            //   alignment: Alignment.center,
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: Text(
            //     widget.groupData!["data"]["mentors"],
            //     textAlign: TextAlign.center,
            //     style: const TextStyle(
            //       fontSize: 30,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
