import 'dart:math';

import 'package:cloudyml_app2/utils/convert_to_two_digits.dart';
import 'package:flutter/material.dart';

Widget timeRemainingString({
  required Duration position,
  required Duration duration,
}) {
  var timeRemaining = duration.toString().substring(2, 7);
  final int getduration = duration.inSeconds;
  final currentPosition = position.inSeconds;
  final timeRemained = max(0, getduration - currentPosition);
  final mins = convertToTwoDigits(timeRemained ~/ 60);
  final seconds = convertToTwoDigits(timeRemained % 60);
  timeRemaining = '$mins:$seconds';

  return Positioned(
    bottom: 33,
    right: 55,
    child: Text(
      timeRemaining,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
