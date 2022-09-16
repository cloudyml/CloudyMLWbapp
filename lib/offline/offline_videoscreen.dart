import 'dart:io';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/models/offline_model.dart';
import 'package:cloudyml_app2/widgets/settings_bottomsheet.dart';
import 'package:cloudyml_app2/widgets/video_player_widgets/fullscreen_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:video_player/video_player.dart';

class VideoScreenOffline extends StatefulWidget {
  final List<OfflineModel> videos;
  const VideoScreenOffline({Key? key, required this.videos}) : super(key: key);
  static ValueNotifier<int> _currentVideoIndex = ValueNotifier(0);
  static ValueNotifier<double> _downloadProgress = ValueNotifier(0);

  @override
  State<VideoScreenOffline> createState() => _VideoScreenOfflineState();
}

class _VideoScreenOfflineState extends State<VideoScreenOffline> {
  VideoPlayerController? _videoController;
  bool? downloading = false;
  bool downloaded = false;
  Map<String, dynamic>? data;
  String? videoUrl;
  Future<void>? playVideo;
  bool enablePauseScreen = false;
  bool showAssignment = false;
  int? serialNo;
  String? assignMentVideoUrl;
  bool _disposed = false;
  bool _isPlaying = false;
  bool _isBuffering = false;
  Duration? _duration;
  Duration? _position;
  bool switchTOAssignment = false;
  bool showAssignSol = false;

  var _delayToInvokeonControlUpdate = 0;
  var _progress = 0.0;

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
      VideoScreenOffline._currentVideoIndex.value++;
      intializeVidController(
        File(widget.videos[VideoScreenOffline._currentVideoIndex.value].path!),
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

  void intializeVidController(File file) async {
    try {
      final oldVideoController = _videoController;
      if (oldVideoController != null) {
        oldVideoController.removeListener(_onVideoControllerUpdate);
        oldVideoController.pause();
        oldVideoController.dispose();
      }
      final _localVideoController = await VideoPlayerController.file(file);
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

  @override
  void initState() {
    // VideoScreen.currentSpeed.value = 1.0;
    intializeVidController(
        File(widget.videos[VideoScreenOffline._currentVideoIndex.value].path!));
    super.initState();
  }

  @override
  void dispose() {
    _disposed = true;
    _videoController!.dispose();
    _videoController = null;
    AutoOrientation.portraitUpMode();
    super.dispose();
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
                                        _videoController!,
                                        widget
                                            .videos[VideoScreenOffline
                                                ._currentVideoIndex.value]
                                            .topic!)
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
                // isPortrait
                //     ? _buildPartition(
                //         context,
                //         horizontalScale,
                //         verticalScale,
                //       )
                //     : SizedBox(),
                isPortrait
                    ? Expanded(
                        flex: 2,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.videos.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Card(
                                color: Color(0xFFDDD2FB),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    onTap: () {
                                      intializeVidController(
                                        File(
                                          widget.videos[index].path!,
                                        ),
                                      );
                                      VideoScreenOffline
                                          ._currentVideoIndex.value = index;
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
                                        icon:
                                            Icon(Icons.download_done_outlined),
                                      ),
                                    ),
                                    enableFeedback: true,
                                    title: Text(
                                      widget.videos[index].topic!,
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
                                  ),
                                ),
                              ),
                            );
                          },
                        ))
                    : SizedBox(),
              ],
            );
          },
        ),
      ),
    ));
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

  Widget _buildControls(
    BuildContext context,
    bool isPortrait,
    double horizontalScale,
    double verticalScale,
    VideoPlayerController _videoController,
    String videoTitle,
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
              videoTitle,
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
                  _videoController,
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
            valueListenable: VideoScreenOffline._currentVideoIndex,
            builder: (context, int value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  value >= 1
                      ? InkWell(
                          onTap: () {
                            VideoScreenOffline._currentVideoIndex.value--;
                            intializeVidController(
                              File(
                                widget
                                    .videos[VideoScreenOffline
                                        ._currentVideoIndex.value]
                                    .path!,
                              ),
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
                                _videoController.pause();
                              });
                            } else {
                              setState(() {
                                enablePauseScreen = !enablePauseScreen;
                                _videoController.play();
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
                  VideoScreenOffline._currentVideoIndex.value <
                          widget.videos.length - 1
                      ? InkWell(
                          onTap: () {
                            VideoScreenOffline._currentVideoIndex.value++;
                            intializeVidController(
                              File(
                                widget
                                    .videos[VideoScreenOffline
                                        ._currentVideoIndex.value]
                                    .path!,
                              ),
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
                    _videoController,
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
                          '/${_videoController.value.duration.toString().substring(2, 7)}',
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
