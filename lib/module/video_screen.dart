import 'dart:io';
import 'dart:math';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:cloudyml_app2/models/video_details.dart';
import 'package:cloudyml_app2/offline/db.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/models/offline_model.dart';
import 'package:cloudyml_app2/module/assignment_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/widgets/assignment_bottomsheet.dart';
import 'package:cloudyml_app2/widgets/settings_bottomsheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final int? sr;
  final bool? isdemo;
  final String? courseName;
  static ValueNotifier<double> currentSpeed = ValueNotifier(1.0);
  const VideoScreen({required this.isdemo, this.sr, this.courseName});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController? _videoController;
  bool? downloading = false;
  bool downloaded = false;
  Map<String, dynamic>? data;
  String? videoUrl;
  Future<void>? playVideo;
  bool showAssignment = false;
  int? serialNo;
  String? assignMentVideoUrl;
  bool _disposed = false;
  bool _isPlaying = false;
  bool enablePauseScreen = false;
  bool _isBuffering = false;
  Duration? _duration;
  Duration? _position;
  bool switchTOAssignment = false;
  bool showAssignSol = false;

  var _delayToInvokeonControlUpdate = 0;
  var _progress = 0.0;
  List<VideoDetails> _listOfVideoDetails = [];

  ValueNotifier<int> _currentVideoIndex = ValueNotifier(0);
  ValueNotifier<double> _downloadProgress = ValueNotifier(0);

  void getData() async {
    await setModuleId();
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('Modules')
        .doc(moduleId)
        .collection('Topics')
        .orderBy('sr')
        .get()
        .then((value) {
      for (var video in value.docs) {
        _listOfVideoDetails.add(
          VideoDetails(
            videoId: video.data()['id'] ?? '',
            type: video.data()['type'] ?? '',
            canSaveOffline: video.data()['Offline'] ?? true,
            serialNo: video.data()['sr'].toString(),
            videoTitle: video.data()['name'] ?? '',
            videoUrl: video.data()['url'] ?? '',
          ),
        );
      }
    });
  }

  Future<void> setModuleId() async {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('Modules')
        .where('firstType', isEqualTo: 'video')
        .get()
        .then((value) {
      moduleId = value.docs[0].id;
    });
  }

  String convertToTwoDigits(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  // Widget timeRemainingString() {
  //   final totalDuration =
  //       _videoController!.value.duration.toString().substring(2, 7);
  //   final duration = _duration?.inSeconds ?? 0;
  //   final currentPosition = _position?.inSeconds ?? 0;
  //   final timeRemained = max(0, duration - currentPosition);
  //   final mins = convertToTwoDigits(timeRemained ~/ 60);
  //   final seconds = convertToTwoDigits(timeRemained % 60);
  //   // timeRemaining = '$mins:$seconds';
  //   return Text(
  //     totalDuration,
  //     style: TextStyle(
  //       color: Colors.white,
  //       fontWeight: FontWeight.bold,
  //     ),
  //   );
  // }

  Widget timeElapsedString() {
    var timeElapsedString = "00.00";
    final currentPosition = _position?.inSeconds ?? 0;
    final mins = convertToTwoDigits(currentPosition ~/ 60);
    final seconds = convertToTwoDigits(currentPosition % 60);
    timeElapsedString = '$mins:$seconds';
    return Text(
      timeElapsedString,
      style: TextStyle(
          color: Colors.white,
          // fontSize: 12,
          fontWeight: FontWeight.bold),
    );
  }

  void _onVideoControllerUpdate() {
    if (_disposed) {
      return;
    }
    final now = DateTime.now().microsecondsSinceEpoch;
    if (_delayToInvokeonControlUpdate > now) {
      return;
    }
    _delayToInvokeonControlUpdate = now + 500;
    final controller = _videoController;
    if (controller == null) {
      debugPrint("The video controller is null");
      return;
    }
    if (!controller.value.isInitialized) {
      debugPrint("The video controller cannot be initialized");
      return;
    }
    if (_duration == null) {
      _duration = _videoController!.value.duration;
    }
    if (!(_videoController!.value.duration >
            _videoController!.value.position) &&
        !_videoController!.value.isPlaying) {
      VideoScreen.currentSpeed.value = 1.0;
      _currentVideoIndex.value++;
      intializeVidController(
        _listOfVideoDetails[_currentVideoIndex.value].videoUrl,
      );
    }
    var duration = _duration;
    if (duration == null) return;
    setState(() {});

    var position = _videoController?.value.position;
    setState(() {
      _position = position;
    });
    final buffering = controller.value.isBuffering;
    setState(() {
      _isBuffering = buffering;
    });
    final playing = controller.value.isPlaying;
    if (playing) {
      if (_disposed) return;
      setState(() {
        _progress = position!.inMilliseconds.ceilToDouble() /
            duration.inMilliseconds.ceilToDouble();
      });
    }
    _isPlaying = playing;
  }

  void intializeVidController(String url) async {
    try {
      final oldVideoController = _videoController;
      if (oldVideoController != null) {
        oldVideoController.removeListener(_onVideoControllerUpdate);
        oldVideoController.pause();
        oldVideoController.dispose();
      }
      final _localVideoController = await VideoPlayerController.network(url);
      setState(() {
        _videoController = _localVideoController;
      });
      playVideo = _localVideoController.initialize().then((value) {
        setState(() {
          _localVideoController.addListener(_onVideoControllerUpdate);
          _localVideoController.play();
          _duration = _localVideoController.value.duration;
        });
      });
    } catch (e) {
      showToast(e.toString());
    }
  }

  void getPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future download({
    Dio? dio,
    String? url,
    String? savePath,
    String? fileName,
    String? courseName,
    String? topicName,
  }) async {
    getPermission();
    var directory = await getApplicationDocumentsDirectory();
    try {
      setState(() {
        downloading = true;
      });
      Response response = await dio!.get(
        url!,
        onReceiveProgress: (rec, total) {
          _downloadProgress.value = rec / total;
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print(response.headers);
      File file = File(savePath!);
      var raf = file.openSync(mode: FileMode.write);
      print('savepath--$savePath');

      raf.writeFromSync(response.data);
      await raf.close();
      DatabaseHelper _dbhelper = DatabaseHelper();
      OfflineModel video = OfflineModel(
          topic: topicName,
          path: '${directory.path}/${fileName!.replaceAll(' ', '')}.mp4');
      _dbhelper.insertTask(video);

      setState(() {
        downloading = false;
        downloaded = true;
      });
    } catch (e) {
      print('e::$e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    AutoOrientation.portraitUpMode();
    _disposed = true;
    _videoController!.dispose();
    _videoController = null;
  }

  @override
  void initState() {
    VideoScreen.currentSpeed.value = 1.0;
    getData();
    Future.delayed(Duration(milliseconds: 500), () {
      intializeVidController(_listOfVideoDetails[0].videoUrl);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    return Scaffold(
        body: SafeArea(
      child: Container(
        color: Colors.white,
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            final isPortrait = orientation == Orientation.portrait;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        enablePauseScreen = !enablePauseScreen;
                      });
                    },
                    child: Container(
                      color: Colors.black,
                      child: FutureBuilder(
                        future: playVideo,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (ConnectionState.done ==
                              snapshot.connectionState) {
                            return Stack(
                              children: [
                                Center(
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: VideoPlayer(_videoController!),
                                  ),
                                ),
                                enablePauseScreen
                                    ? _buildControls(
                                        context,
                                        isPortrait,
                                        horizontalScale,
                                        verticalScale,
                                      )
                                    : SizedBox(),
                                _isBuffering && !enablePauseScreen
                                    ? Center(
                                        heightFactor: 6.2,
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          child: CircularProgressIndicator(
                                            color: Color.fromARGB(
                                              114,
                                              255,
                                              255,
                                              255,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF7860DC),
                              ),
                            );
                          }
                        },
                      ),
                      // },
                      // ),
                    ),
                  ),
                ),
                isPortrait
                    ? _buildPartition(
                        context,
                        horizontalScale,
                        verticalScale,
                      )
                    : SizedBox(),
                isPortrait
                    ? Expanded(
                        flex: 2,
                        child: _buildVideoDetailsListTile(
                          horizontalScale,
                          verticalScale,
                        ),
                      )
                    : SizedBox(),
              ],
            );
          },
        ),
      ),
    ));
  }

  Widget _buildControls(
    BuildContext context,
    bool isPortrait,
    double horizontalScale,
    double verticalScale,
  ) {
    return Container(
      color: Color.fromARGB(114, 0, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListTile(
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
            ),
            title: Text(
              _listOfVideoDetails[_currentVideoIndex.value].videoTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            trailing: InkWell(
              onTap: () {
                showSettingsBottomsheet(
                  context,
                  horizontalScale,
                  verticalScale,
                  _videoController!,
                );
                // var directory = await getApplicationDocumentsDirectory();
                // download(
                //   dio: Dio(),
                //   fileName: data!['name'],
                //   url: data!['url'],
                //   savePath:
                //       "${directory.path}/${data!['name'].replaceAll(' ', '')}.mp4",
                //   topicName: data!['name'],
                // );
                // print(directory.path);
              },
              child: Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _currentVideoIndex,
            builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _currentVideoIndex.value >= 1
                      ? InkWell(
                          onTap: () {
                            VideoScreen.currentSpeed.value = 1.0;
                            _currentVideoIndex.value--;
                            intializeVidController(
                              _listOfVideoDetails[_currentVideoIndex.value]
                                  .videoUrl,
                            );
                          },
                          child: Icon(
                            Icons.skip_previous_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        )
                      : SizedBox(),
                  replay10(
                    videoController: _videoController,
                  ),
                  !_isBuffering
                      ? InkWell(
                          onTap: () {
                            if (_isPlaying) {
                              setState(() {
                                _videoController!.pause();
                              });
                            } else {
                              setState(() {
                                enablePauseScreen = !enablePauseScreen;
                                _videoController!.play();
                              });
                            }
                          },
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 50,
                          ),
                        )
                      : CircularProgressIndicator(
                          color: Color.fromARGB(
                            114,
                            255,
                            255,
                            255,
                          ),
                        ),
                  fastForward10(
                    videoController: _videoController,
                  ),
                  _currentVideoIndex.value < _listOfVideoDetails.length - 1
                      ? InkWell(
                          onTap: () {
                            VideoScreen.currentSpeed.value = 1.0;
                            _currentVideoIndex.value++;
                            intializeVidController(
                              _listOfVideoDetails[_currentVideoIndex.value]
                                  .videoUrl,
                            );
                          },
                          child: Icon(
                            Icons.skip_next_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        )
                      : SizedBox(),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Container(
                  height: 10,
                  child: VideoProgressIndicator(
                    _videoController!,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      backgroundColor: Color.fromARGB(74, 255, 255, 255),
                      bufferedColor: Color(0xFFC0AAF5),
                      playedColor: Color(0xFF7860DC),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        timeElapsedString(),
                        Text(
                          '/${_videoController!.value.duration.toString().substring(2, 7)}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    fullScreenIcon(
                      isPortrait: isPortrait,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _buildPartition(
      BuildContext context, double horizontalScale, double verticalScale) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.courseName!,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "Medium",
              ),
            ),
          ),
        ),
        SizedBox(
          height: 60,
          child: Center(
            child: Row(
              children: [
                SizedBox(width: 20),
                _buildLecturesTab(context),
                SizedBox(width: 30),
                _buildAssignmentTab(
                  context,
                  horizontalScale,
                  verticalScale,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container _buildLecturesTab(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Lectures',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            height: 3,
            width: MediaQuery.of(context).size.width * 0.2,
            color: Color(0xFF7860DC),
          )
        ],
      ),
    );
  }

  InkWell _buildAssignmentTab(
      BuildContext context, double horizontalScale, double verticalScale) {
    return InkWell(
      onTap: () {
        setState(() {
          _videoController!.pause();
          showAssignmentBottomSheet(
            context,
            horizontalScale,
            verticalScale,
          );
        });
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Assignments',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              height: 3,
              width: MediaQuery.of(context).size.width * 0.25,
              color: Color(0xFF7860DC),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildVideoDetailsListTile(
      double horizontalScale, double verticalScale) {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .collection('Modules')
            .doc(moduleId)
            .collection('Topics')
            .orderBy('sr')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> map = snapshot.data!.docs[index].data();
                  return Card(
                    elevation: 0,
                    color: _currentVideoIndex.value == index
                        ? Color(0xFFDDD2FB)
                        : Colors.white,
                    child: ListTile(
                      onTap: () {
                        VideoScreen.currentSpeed.value = 1.0;
                        intializeVidController(
                          _listOfVideoDetails[index].videoUrl,
                        );
                        _currentVideoIndex.value = index;
                      },
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${index + 1}'),
                      ),
                      title: Text(
                        map['name'],
                        textScaleFactor: min(
                          horizontalScale,
                          verticalScale,
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          fontFamily: "Medium",
                        ),
                      ),
                      trailing: InkWell(
                        onTap: () async {
                          var directory =
                              await getApplicationDocumentsDirectory();
                          _currentVideoIndex.value = index;
                          download(
                              dio: Dio(),
                              fileName: map['name'],
                              url: map['url'],
                              savePath:
                                  "${directory.path}/${map['name'].replaceAll(' ', '')}.mp4",
                              topicName: map['name'],
                              courseName: widget.courseName);
                        },
                        child: _currentVideoIndex.value == index
                            ? Stack(
                                children: [
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    top: 0,
                                    child: Icon(
                                      Icons.download_for_offline_rounded,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      value: _downloadProgress.value,
                                      color: Color(0xFF7860DC),
                                      backgroundColor: Color(0xFFDDD2FB),
                                    ),
                                  )
                                ],
                              )
                            : Icon(
                                Icons.download_for_offline_rounded,
                              ),
                      ),
                    ),
                  );
                });
          } else {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Lottie.asset('assets/load-shimmer.json',
                  fit: BoxFit.fill, reverse: true),
            );
          }
        },
      ),
    );
  }
}

class replay10 extends StatelessWidget {
  const replay10({
    Key? key,
    required VideoPlayerController? videoController,
  })  : _videoController = videoController,
        super(key: key);

  final VideoPlayerController? _videoController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() async {
        final currentPosition = await _videoController!.position;
        final newPosition = currentPosition! - Duration(seconds: 10);
        _videoController!.seekTo(newPosition);
      }),
      child: Icon(
        Icons.replay_10,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}

class fastForward10 extends StatelessWidget {
  const fastForward10({
    Key? key,
    required VideoPlayerController? videoController,
  })  : _videoController = videoController,
        super(key: key);

  final VideoPlayerController? _videoController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() async {
        final currentPosition = await _videoController!.position;
        final newPosition = currentPosition! + Duration(seconds: 10);
        _videoController!.seekTo(newPosition);
      }),
      child: Icon(
        Icons.forward_10,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}

class fullScreenIcon extends StatelessWidget {
  const fullScreenIcon({
    Key? key,
    required this.isPortrait,
  }) : super(key: key);

  final bool isPortrait;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IconButton(
        onPressed: () {
          if (isPortrait) {
            AutoOrientation.landscapeRightMode();
          } else {
            AutoOrientation.portraitUpMode();
          }
        },
        icon: Icon(
          isPortrait ? Icons.fullscreen_rounded : Icons.fullscreen_exit_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
