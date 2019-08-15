import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:bss/post/post-image/post_video.dart';
import 'package:bss/service/service_provider.dart';
import 'package:bss/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';

import '../../helper.dart';

class PostImageController extends BaseController {
  final void Function(double imageWidth) returnImageWidth;

  final GlobalKey imageSizeKey = GlobalKey();

  final List<AdvancedNetworkImage> imageList;

  int imageIndex = 0;

  double imageHeight;

  bool video = true;

  double imageWidth;

  PostImageController({
    this.returnImageWidth,
    this.imageList,
    this.imageHeight,
    this.imageWidth,
  });

  @override
  void initState() {
    super.initState();
  }
}

class PostImage extends BaseView {
  final PostImageController controller;

  PostImage({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    List<Widget> tabBarWidgets = <Widget>[];
    for (int i = 0; i < controller.imageList.length; i++) {
      double left = 2.5;
      double right = 2.5;
      if (i == 0) left = 5;
      if (i == controller.imageList.length - 1) right = 5;
      tabBarWidgets.add(Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: left, right: right),
          child: Container(
            color: controller.imageIndex == i
                ? Colors.white
                : Color.fromRGBO(0, 0, 0, 0.25),
          ),
        ),
      ));
    }
    return Container(
      padding: EdgeInsets.only(
        left: getDefaultPadding(context) * 2,
        right: getDefaultPadding(context) * 2,
      ),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              key: controller.imageSizeKey,
              child: TransitionToImage(
                image: controller.imageList[controller.imageIndex],
                loadingWidget: Center(child: CPI(false)),
              ),
            ),
          ),
          if (controller.imageHeight != null) ...[
            Positioned(
              left: 0,
              top: 0,
              child: GestureDetector(
                onTap: () {
                  if (controller.imageIndex != 0) {
                    controller.imageIndex--;
                    controller.refresh();
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  height: controller.imageHeight,
                  width: controller.imageWidth / 2,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: () {
                  if (controller.imageIndex + 1 < controller.imageList.length) {
                    controller.imageIndex++;
                    controller.refresh();
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  height: controller.imageHeight,
                  width: controller.imageWidth / 2,
                ),
              ),
            ),
            Positioned(
              top: ServiceProvider.instance.screenService
                  .getHeightByPercentage(context, 1),
              child: Container(
                height: 2.5,
                width: controller.imageWidth,
                child: Row(
                  children: tabBarWidgets,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
