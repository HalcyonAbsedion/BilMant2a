// ignore_for_file: deprecated_member_use

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerPage({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late CustomVideoPlayerController _customVideoPlayerController;
  late bool isLoading = true;

  @override
  void initState() {
    super.initState();
    VideoPlayerController videoPlayerController =
        VideoPlayerController.network(widget.videoUrl);
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );

    videoPlayerController.initialize().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : CustomVideoPlayer(
              customVideoPlayerController: _customVideoPlayerController,
            ),
    );
  }
}
