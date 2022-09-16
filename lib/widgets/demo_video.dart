import 'package:auto_orientation/auto_orientation.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:video_player/video_player.dart';

class VideoPlayerCustom extends StatefulWidget {
  final String url;
  VideoPlayerCustom({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerCustomState createState() => _VideoPlayerCustomState();
}

class _VideoPlayerCustomState extends State<VideoPlayerCustom> {
  BetterPlayerController? _betterPlayerController;

  @override
  void initState() {
    super.initState();
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      autoPlay: true,
      aspectRatio: 16 / 9,
      fullScreenAspectRatio: 16 / 9,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      autoDispose: true,
      fit: BoxFit.cover,
      // expandToFill: true,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        iconsColor: Color(0xFFDDD2FB),
        loadingColor: Color(0xFFDDD2FB),
      ),
    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.url,
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController?.setupDataSource(dataSource);
  }

  @override
  void dispose() {
    AutoOrientation.portraitAutoMode();
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 80,
        toolbarOpacity: 0.8,
        elevation: 0.00,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BetterPlayer(
          controller: _betterPlayerController!,
        ),
      ),
    );
  }
}
