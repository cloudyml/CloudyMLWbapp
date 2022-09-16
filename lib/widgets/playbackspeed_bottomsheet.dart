import 'dart:math';

import 'package:cloudyml_app2/module/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

Future<dynamic> showPlaybackSpeedBottomsheet(
  BuildContext context,
  double horizontalScale,
  double verticalScale,
  VideoPlayerController controller,
) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    isDismissible: true,
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          // height: 250,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 8,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.pop(context);
                  controller.setPlaybackSpeed((index + 1) * 0.25);
                  VideoScreen.currentSpeed.value = (index + 1) * 0.25;
                },
                leading: VideoScreen.currentSpeed.value == (index + 1) * 0.25
                    ? Icon(Icons.check)
                    : SizedBox(),
                title: ((index + 1) * 0.25) == 1.0
                    ? Text('Normal')
                    : Text(
                        '${(index + 1) * 0.25}',
                      ),
              );
            },
          ),
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     ListTile(
          //       leading: Icon(Icons.speed),
          //       title: Text('Playback speed'),
          //     ),
          //     InkWell(
          //       onTap: (){
          //         Navigator.pop(context);
          //       },
          //       child: ListTile(
          //         title: Icon(Icons.close),
          //       ),
          //     )
          //   ],
          // ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Text(
          //       'As assignments cant open on mobile please open below link on Laptop browser to get Assignment and Course certificates.',
          //       textAlign: TextAlign.center,
          //       textScaleFactor: min(horizontalScale, verticalScale),
          //       style: TextStyle(
          //         fontFamily: 'Poppins',
          //         fontSize: 16,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //     SelectableText(
          //       'https://courses.cloudyml.com/s/store',
          //       style: TextStyle(
          //         fontFamily: 'Poppins',
          //         fontSize: 16,
          //         fontWeight: FontWeight.w900,
          //       ),
          //     ),
          //     Text(
          //       'To Open LMS On Mobile Please Click Below',
          //       style: TextStyle(
          //         fontFamily: 'Poppins',
          //         fontSize: 16,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //     ElevatedButton(
          //       style: ButtonStyle(
          //         backgroundColor: MaterialStateProperty.all(
          //           Color(0xFF7860DC),
          //         ),
          //       ),
          //       onPressed: () {
          //         Utils.openLink(Url: 'https://courses.cloudyml.com/s/store');
          //       },
          //       child: Text('Open Url'),
          //     ),
          //   ],
          // ),
        ),
      );
    },
  );
}
