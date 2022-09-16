import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';

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