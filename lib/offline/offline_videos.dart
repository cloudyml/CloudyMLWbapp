import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/offline/db.dart';
import 'package:cloudyml_app2/models/offline_model.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/offline/offline_videoscreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class OfflinePage extends StatefulWidget {
  final int? sr;
  const OfflinePage({this.sr});

  @override
  _OfflinePageState createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  bool? loading = true;
  bool showVideo = false;
  List<OfflineModel> videos = [];
  ChewieController? _chewieController;
  VideoPlayerController? _videoController;

  Future<void> getVideos() async {
    DatabaseHelper _dbhelper = DatabaseHelper();
    videos = await _dbhelper.getTasks();
    setState(() {
      loading = false;
    });
  }

  void getData() async {
    //--/data/user/0/com.cloudyml.cloudymlapp/app_flutter/file.mp4
    //--/data/user/0/com.cloudyml.cloudymlapp/app_flutter/LogicalOperators.mp4
    File videoFile = File(videos[0].path!);

    try {
      _videoController = VideoPlayerController.file(
        videoFile,
      )..initialize().then((value) {
          _videoController!.setLooping(false);
          _chewieController = ChewieController(
            materialProgressColors: ChewieProgressColors(
                playedColor: Color(0xFFaefb2a), handleColor: Color(0xFFaefb2a)),
            cupertinoProgressColors: ChewieProgressColors(
                playedColor: Color(0xFFaefb2a), handleColor: Color(0xFFaefb2a)),
            videoPlayerController: _videoController!,
            looping: false,
          );
          setState(() {
            loading = false;
          });
        });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  void initializeVideoController(String path) {
    File videoFile = File(path);
    try {
      final _oldVideoController = _videoController;
      final _oldChewieController = _chewieController;
      if (_oldVideoController != null) {
        _videoController!.dispose();
      }
      if (_oldChewieController != null) {
        _chewieController!.dispose();
      }
      _videoController = VideoPlayerController.file(
        videoFile,
      )..initialize().then((value) {
          _videoController!.setLooping(false);
          _chewieController = ChewieController(
            materialProgressColors: ChewieProgressColors(
                playedColor: Color(0xFFaefb2a), handleColor: Color(0xFFaefb2a)),
            cupertinoProgressColors: ChewieProgressColors(
                playedColor: Color(0xFFaefb2a), handleColor: Color(0xFFaefb2a)),
            videoPlayerController: _videoController!,
            looping: false,
          );
          setState(() {
            loading = false;
          });
        });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    AutoOrientation.portraitUpMode();
    getData();
    getVideos();
    super.initState();
  }

  @override
  void dispose() {
    _videoController!.dispose();
    _chewieController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: false,
              backgroundColor: Colors.white,
              expandedHeight: 150,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(
                  left: 50,
                  top: 100,
                ),
                centerTitle: true,
                title: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        // size: 30 * min(horizontalScale, verticalScale),
                      ),
                    ),
                    SizedBox(width: 10),
                    Center(
                      child: Text(
                        'Offline-Videos',
                        // textScaleFactor: min(horizontalScale, verticalScale),
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontFamily: 'Poppins',
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                collapseMode: CollapseMode.parallax,
                background: Container(
                  width: 414 * horizontalScale,
                  // height: 217 * verticalScale,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    color: Color.fromRGBO(122, 98, 222, 1),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -15 * verticalScale,
                        right: -15 * horizontalScale,
                        child: Container(
                          width: 128 * min(horizontalScale, verticalScale),
                          height: 128 * min(verticalScale, horizontalScale),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(129, 105, 229, 1),
                            borderRadius: BorderRadius.all(
                              Radius.elliptical(128, 128),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 80 * verticalScale,
                        left: -31 * horizontalScale,
                        child: Container(
                          width: 62 * min(horizontalScale, verticalScale),
                          height: 62 * min(verticalScale, horizontalScale),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(129, 105, 229, 1),
                            borderRadius: BorderRadius.all(
                              Radius.elliptical(62, 62),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: videos.isEmpty
            ? Center(
                child: Text(
                  'No downloaded videos',
                  style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 20,
                      color: Colors.black.withOpacity(0.4)),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: videos.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VideoScreenOffline(videos: videos),
                        ),
                      );
                    },
                    autofocus: true,
                    // trailing: Card(
                    //   color: Colors.transparent,
                    //   child: IconButton(
                    //     onPressed: () {
                    //       // Utils.downloadPdf(
                    //       //   context: context,
                    //       //   pdfName: widget.curriculum['Company Names'][index],
                    //       // );
                    //     },
                    //     icon: Icon(Icons.download_done_outlined),
                    //   ),
                    // ),
                    leading: Card(
                      child: IconButton(
                        onPressed: () {
                          // Utils.downloadPdf(
                          //   context: context,
                          //   pdfName: widget.curriculum['Company Names'][index],
                          // );
                        },
                        icon: Icon(Icons.download_done_outlined),
                      ),
                    ),
                    enableFeedback: true,
                    title: Text(
                      videos[index].topic!,
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: 'Poppins',
                        letterSpacing: 0,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    // subtitle: Text(
                    //   videos[index].course ?? '',
                    //   style: TextStyle(
                    //     // color: Color.fromARGB(255, 0, 0, 0),
                    //     fontFamily: 'Poppins',
                    //     letterSpacing: 0,
                    //   ),
                    // )
                    // videos[index].course,
                  );
                },
              ),
      ),
    );
  }
}

// class OfflineViewer extends StatefulWidget {
//   final String? topic;
//   final String? path;
//   const OfflineViewer(
//       {Key? key, this.topic, /* this.module, this.course,*/ this.path})
//       : super(key: key);

//   @override
//   State<OfflineViewer> createState() => _OfflineViewerState();
// }

// class _OfflineViewerState extends State<OfflineViewer> {
//   ChewieController? _chewieController;
//   VideoPlayerController? _videoController;
//   bool? loading = true;
//   void getData() async {
//     //--/data/user/0/com.cloudyml.cloudymlapp/app_flutter/file.mp4
//     //--/data/user/0/com.cloudyml.cloudymlapp/app_flutter/LogicalOperators.mp4

//     File videoFile = File(widget.path!);

//     try {
//       _videoController = VideoPlayerController.file(
//         videoFile,
//       )..initialize().then((value) {
//           _videoController!.setLooping(false);
//           _chewieController = ChewieController(
//             materialProgressColors: ChewieProgressColors(
//                 playedColor: Color(0xFFaefb2a), handleColor: Color(0xFFaefb2a)),
//             cupertinoProgressColors: ChewieProgressColors(
//                 playedColor: Color(0xFFaefb2a), handleColor: Color(0xFFaefb2a)),
//             videoPlayerController: _videoController!,
//             looping: false,
//           );
//           setState(() {
//             loading = false;
//           });
//         });
//     } catch (e) {
//       setState(() {
//         loading = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         loading!
//             ? Container()
//             : Container(
//                 height: (MediaQuery.of(context).size.width * 9) / 16,
//                 width: MediaQuery.of(context).size.width,
//                 child: Theme(
//                     data: ThemeData.light().copyWith(
//                       platform: TargetPlatform.android,
//                     ),
//                     child: Chewie(controller: _chewieController!))),
//         SizedBox(
//           height: 20,
//         ),
//         // Padding(
//         //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
//         //   child: Text(
//         //     widget.topic!,
//         //     style: TextStyle(
//         //         fontFamily: 'Bold', fontSize: 24, color: Colors.black),
//         //   ),
//         // ),
//         // Padding(
//         //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
//         //   child: Row(
//         //     children: [
//         //       Text(
//         //         widget.course!,
//         //         style: TextStyle(
//         //             fontFamily: 'SemiBold',
//         //             fontSize: 16,
//         //             color: Colors.black.withOpacity(0.7)),
//         //       ),
//         //       Text('  . ${widget.module!}',
//         //           style: TextStyle(
//         //               fontFamily: 'Medium',
//         //               fontSize: 16,
//         //               color: Colors.black.withOpacity(0.5))),
//         //     ],
//         //   ),
//         // ),
//         SizedBox(
//           height: 30,
//         ),
//       ],
//     );
//   }
// }
