// import 'dart:math';

// import 'package:flutter/material.dart';

// Widget progressIndicator({required BuildContext context,}) {
//     return Positioned(
//       bottom: 27,
//       left: 0,
//       right: 0,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 50, right: 95),
//         child: SliderTheme(
//           data: SliderTheme.of(context).copyWith(
//             activeTrackColor: Color(0xFFC0AAF5),
//             inactiveTrackColor: Color.fromARGB(135, 221, 210, 251),
//             trackShape: RoundedRectSliderTrackShape(),
//             trackHeight: 3,
//             thumbShape: RoundSliderThumbShape(
//               enabledThumbRadius: 10,
//               elevation: 1,
//             ),
//             thumbColor: Colors.white,
//             overlayColor: Color.fromARGB(80, 255, 255, 255),
//             overlayShape: RoundSliderOverlayShape(
//               overlayRadius: 14,
//             ),
//             tickMarkShape: RoundSliderTickMarkShape(),
//             activeTickMarkColor: Color(0xFFC0AAF5),
//             inactiveTickMarkColor: Color(0xFFDDD2FB),
//           ),
//           child: Slider(
//             value: max(0, min(_progress * 100, 100)),
//             min: 0,
//             max: 100,
//             divisions: 100,
//             // label: _position?.toString().split(".")[0],
//             onChanged: (value) {
//               setState(() {
//                 _progress = value * 0.01;
//               });
//             },
//             onChangeStart: (value) {
//               _videoController?.pause();
//             },
//             onChangeEnd: (value) {
//               final duration = _videoController?.value.duration;
//               if (duration != null) {
//                 var newValue = max(0, min(value, 99)) * 0.01;
//                 var millis = (duration.inMilliseconds * newValue).toInt();
//                 _videoController?.seekTo(Duration(milliseconds: millis));
//                 _videoController?.play();
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
