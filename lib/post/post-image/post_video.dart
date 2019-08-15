import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PostVideoController extends BaseController {
  final GlobalKey videoSizeKey;

  VideoPlayerController _videoController;

  final VoidCallback videoHasLoaded;

  PostVideoController({this.videoHasLoaded, this.videoSizeKey});

  @override
  void initState() {
    _videoController = VideoPlayerController.network(
        'https://firebasestorage.googleapis.com/v0/b/innafor-f4e41.appspot.com/o/12345.png?alt=media&token=d8a7c03d-0b78-4318-83ff-3123b721a2d7')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _videoController.setLooping(true);
        _videoController.play();
        print("width" + _videoController.value.size.width.toString());
        refresh();
      });
    super.initState();
  }
}

class PostVideo extends BaseView {
  final PostVideoController controller;

  PostVideo({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();
    return Center(
      child: GestureDetector(
        onTap: () {
          controller._videoController.value.isPlaying
              ? controller._videoController.pause()
              : controller._videoController.play();
          controller.refresh();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            // width: 360,
            key: controller.videoSizeKey,
            child: AspectRatio(
              aspectRatio: controller._videoController.value.aspectRatio,
              child: controller._videoController.value.initialized
                  ? VideoPlayer(controller._videoController)
                  : Container(),
            ),
          ),
        ),
      ),
    );
  }
}
