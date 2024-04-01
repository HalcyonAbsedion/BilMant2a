import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
// import 'package:pod_player/pod_player.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerPage({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late CustomVideoPlayerController _customVideoPlayerController;
  // late final PodPlayerController controller;

  late bool isLoading = true;

  @override
  void initState() {
    // controller = PodPlayerController(
    //   playVideoFrom: PlayVideoFrom.network(
    //     widget.videoUrl,
    //   ),
    // )..initialise();
    super.initState();

    // Initialize the video player controller
    initializeVideoPlayer();
  }

  @override
  void dispose() {
    // controller.dispose();
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  void initializeVideoPlayer() {
    setState(() {
      isLoading = true;
    });
    VideoPlayerController _videoPlayerController;

    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then((value) {
            setState(() {
              isLoading = false;
            });
          });

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
    );
  }

  void toggleVideoPlayback() {
    if (_customVideoPlayerController.videoPlayerController.value.isPlaying) {
      _customVideoPlayerController.videoPlayerController.pause();
      _customVideoPlayerController
          .customVideoPlayerSettings.autoFadeOutControls;
    } else {
      _customVideoPlayerController.videoPlayerController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    // return PodVideoPlayer(controller: controller);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          )
        : AspectRatio(
            aspectRatio: _customVideoPlayerController
                .videoPlayerController.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                CustomVideoPlayer(
                  customVideoPlayerController: _customVideoPlayerController,
                ),
                // Positioned.fill(
                //   child: GestureDetector(
                //     onTap: toggleVideoPlayback,
                //     behavior: HitTestBehavior.translucent,
                //   ),
                // ),
              ],
            ),
          );
  }
}
