import 'package:cloudyml_app2/utils/convert_to_two_digits.dart';
import 'package:flutter/material.dart';

Widget timeElapsedString({required Duration position}) {
  var timeElapsedString = "00.00";
  final currentPosition = position.inSeconds;
  final mins = convertToTwoDigits(currentPosition ~/ 60);
  final seconds = convertToTwoDigits(currentPosition % 60);
  timeElapsedString = '$mins:$seconds';
  return Positioned(
    bottom: 33,
    left: 10,
    right: 0,
    child: Text(
      timeElapsedString,
      style: TextStyle(
          color: Colors.white,
          // fontSize: 12,
          fontWeight: FontWeight.bold),
    ),
  );
}
