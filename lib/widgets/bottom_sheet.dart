import 'dart:async';

import 'package:flutter/material.dart';

class StatefulBottomSheet extends StatefulWidget {
  var size;
  late VoidCallback startRecording;
  late VoidCallback stopRecording;
  late VoidCallback cancelRecording;
  StatefulBottomSheet(
      {this.size,
      required this.startRecording,
      required this.stopRecording,
      required this.cancelRecording});

  @override
  State<StatefulBottomSheet> createState() => _StatefulBottomSheetState();
}

class _StatefulBottomSheetState extends State<StatefulBottomSheet> {
  DateTime? startTime;
  Timer? timer;
  String recordDuration = "00:00";

  void startTimer() {
    startTime = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final minDur = DateTime.now().difference(startTime!).inMinutes;
      final secDur = DateTime.now().difference(startTime!).inSeconds % 60;
      String min = minDur < 10 ? "0$minDur" : minDur.toString();
      String sec = secDur < 10 ? "0$secDur" : secDur.toString();
      setState(() {
        recordDuration = "$min:$sec";
      });
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    startTime = null;
    recordDuration = "00:00";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50),
      height: widget.size.height * 0.5,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text(recordDuration,
            style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        const Text("Recording...",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                widget.cancelRecording();
                Navigator.pop(context);
              },
              child: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 141, 5, 136),
                radius: widget.size.width * 0.1,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                widget.stopRecording();
                Navigator.pop(context);
              },
              child: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 141, 5, 136),
                radius: widget.size.width * 0.1,
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
