import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../constants.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final List waveforms;

  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
    required this.waveforms,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  bool _isPaused = false;
  final playbackProgress = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
      });

    videoPlayerController.addListener(() {
      playbackProgress.value = videoPlayerController.value.position.inMilliseconds /
          videoPlayerController.value.duration.inMilliseconds;
    });

  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    playbackProgress.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: InkWell(
        onTap: () {
          if (_isPaused) {
            videoPlayerController.play();
                _isPaused = false;
          } else {
            videoPlayerController.pause();
            _isPaused = true;
          }
        },
          child: Stack(
              children: [
                VideoPlayer(videoPlayerController),
                Positioned(
                  bottom: 20,
                  child: Align(
                    alignment: Alignment.center,
                    child: ValueListenableBuilder<double>(
                      valueListenable: playbackProgress,
                      builder: (context, value, child) => GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          final RenderBox box = context.findRenderObject() as RenderBox;
                          final double screenWidth = box.size.width;
                          final double newPosition =
                              details.localPosition.dx / screenWidth * videoPlayerController.value.duration.inMilliseconds;
                          videoPlayerController.seekTo(Duration(milliseconds: newPosition.toInt()));
                          videoPlayerController.pause();
                        },
                        onHorizontalDragEnd: (details) {
                          videoPlayerController.play();
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: (size.width - (size.width * .80)) / 2,
                              right: (size.width - (size.width * .80)) / 2,
                          ),
                          child: CustomPaint(
                            painter: WaveformPainter(
                                widget.waveforms,
                              videoPlayerController.value.position.inMilliseconds /
                                  videoPlayerController.value.duration.inMilliseconds,
                            ),
                            size: Size(size.width * .80, 115),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List wavetable;
  late double progress;

  WaveformPainter(this.wavetable, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress.isNaN) {
      progress = 0;
    }
    print(progress);
    final double spaceBetweenPoints = size.width / wavetable.length;
    final double halfHeight = size.height / 2;
    final int playedWaveCount = (progress * wavetable.length).toInt();

    for (int i = 0; i < wavetable.length; i++) {
      final double xPos = i * spaceBetweenPoints;
      final double height = halfHeight + wavetable[i] * halfHeight;
      final rect = Rect.fromLTWH(xPos, halfHeight - height / 2, spaceBetweenPoints, height);

      final paint = Paint()
        ..color = i < playedWaveCount ? green : Colors.white
        ..strokeWidth = 1.0;

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

