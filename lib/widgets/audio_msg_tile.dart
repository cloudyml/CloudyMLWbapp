import 'dart:io';

import 'package:cloudyml_app2/widgets/audio_bubble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/file_handler.dart';

class AudioMsgTile extends StatefulWidget {
  final size;
  final Map<String, dynamic>? map;
  final appStorage;
  final displayName;
  AudioMsgTile({this.size, this.map, this.appStorage, this.displayName});

  @override
  State<AudioMsgTile> createState() => _AudioMsgTileState();
}

class _AudioMsgTileState extends State<AudioMsgTile> {
  var filePath;

  checkFileExists(fileName) async {
    final file = File("${widget.appStorage!.path}/$fileName");

    if (!file.existsSync()) {
      final file = File("${widget.appStorage!.path}/$fileName");
      await downloadFile(widget.map!["link"], fileName, file);
      setState(() {
        filePath = file.path;
      });
    } else {
      setState(() {
        filePath = file.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    checkFileExists(widget.map!["message"]);
    return Container(
      width: widget.size.width,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      alignment: widget.map!['sendBy'] == widget.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        width: widget.size.width * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Color(0xFF7860DC)
          // gradient: const RadialGradient(
          //     center: Alignment.topRight,
          //     // near the top right
          //     radius: 6,
          //     colors: [
          //       Colors.purple,
          //       Colors.blue,
          //     ]),
        ),
        alignment: Alignment.center,
        child: widget.map!["link"] != ""
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Text(
                      widget.map!["sendBy"],
                      style: TextStyle(
                          color: Color.fromARGB(255, 84, 215, 184),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: AudioBubble(filepath: filePath),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200.withOpacity(0.5)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      DateFormat('hh:mm a')
                          .format(widget.map!["time"].toDate())
                          .toLowerCase(),
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    constraints: BoxConstraints(
                      minWidth: widget.size.width * 0.2,
                    ),
                  )
                ],
              )
            : Container(
                height: widget.size.height * 0.15,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
