import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioBubble extends StatefulWidget {
  final String filepath;

  AudioBubble({required this.filepath});

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble> {
  final player = AudioPlayer();
  Duration? duration;

  @override
  void initState() {
    super.initState();
    player.setFilePath(widget.filepath).then((value) {
      setState(() {
        duration = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        height: 40,
        padding: const EdgeInsets.only(left: 12, right: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(height: 4),
            Row(
              children: [
                StreamBuilder<PlayerState>(
                  stream: player.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState;
                    final playing = playerState?.playing;
                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return GestureDetector(
                        child: const Icon(Icons.play_arrow),
                        onTap: player.play,
                      );
                    } else if (playing != true) {
                      return GestureDetector(
                        child: const Icon(Icons.play_arrow),
                        onTap: player.play,
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return GestureDetector(
                        child: const Icon(Icons.pause),
                        onTap: player.pause,
                      );
                    } else {
                      return GestureDetector(
                        child: const Icon(Icons.replay),
                        onTap: () {
                          player.seek(Duration.zero);
                        },
                      );
                    }
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: StreamBuilder<Duration>(
                    stream: player.positionStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: snapshot.data!.inMilliseconds /
                                  (duration?.inMilliseconds ?? 1),
                              color: Colors.white,
                              backgroundColor: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  prettyDuration(snapshot.data! == Duration.zero
                                      ? duration ?? Duration.zero
                                      : snapshot.data!),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                ),
                                const Text(
                                  "M4A",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return const LinearProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String prettyDuration(Duration d) {
    var min = d.inMinutes < 10 ? "0${d.inMinutes}" : d.inMinutes.toString();
    var sec = d.inSeconds < 10 ? "0${d.inSeconds}" : d.inSeconds.toString();
    return min + ":" + sec;
  }
}
