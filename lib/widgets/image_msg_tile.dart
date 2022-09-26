import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/file_handler.dart';
import 'dart:io';

class ImageMsgTile extends StatefulWidget {
  final Map<String, dynamic>? map;
  final String? displayName;
  final String? appStorage;
  ImageMsgTile({this.map, this.displayName, this.appStorage});

  @override
  State<ImageMsgTile> createState() => _ImageMsgTileState();
}

class _ImageMsgTileState extends State<ImageMsgTile> {
  var filePath;

  String? checkImageExists(fileName) {
    final file = File("${widget.appStorage}/$fileName");

    if (!file.existsSync()) {
      final file = File("${widget.appStorage}/$fileName");
      downloadFile(widget.map!["link"], fileName, file);
      return null;
    } else {
      setState(() {
        filePath = file.path;
      });
      return file.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      alignment: widget.map!['sendBy'] == widget.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          openFile(url: widget.map!["link"], fileName: widget.map!["message"]);
        },
        child: Container(
          width: size.width * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Color(0xFF7860DC),
          ),
          alignment: Alignment.center,
          child: widget.map!['link'] != ""
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
                      constraints: BoxConstraints(minHeight: size.width * 0.5),
                      child: checkImageExists(widget.map!["message"]) != null
                          ? Image.file(
                              File(filePath),
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              widget.map!["link"],
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
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
                        minWidth: size.width * 0.2,
                      ),
                    )
                  ],
                )
              : Container(
                  height: size.width * 0.5,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ),
      ),
    );
  }
}
