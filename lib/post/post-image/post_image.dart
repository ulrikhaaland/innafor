import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:bss/post/post-image/post_image_tab_bar.dart';
import 'package:bss/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

import '../../helper.dart';

class PostImageController extends BaseController {
  final void Function(double imageWidth) returnImageWidth;

  final GlobalKey imageSizeKey = GlobalKey();

  final List<AdvancedNetworkImage> imageList;

  int imageIndex = 0;

  double imageHeight;

  double imageWidth;

  PostImageController({
    this.returnImageWidth,
    this.imageList,
    this.imageHeight,
    this.imageWidth,
  });

  void getImageWidth() {
    final RenderBox renderBoxRed =
        imageSizeKey.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;
    print(sizeRed.width);
    imageWidth = sizeRed.width;
    imageHeight = sizeRed.height;
    returnImageWidth(imageWidth);
    refresh();
  }
}

class PostImage extends BaseView {
  final PostImageController controller;

  PostImage({this.controller});

  @override
  Widget build(BuildContext context) {
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
              color: ServiceProvider
                  .instance.instanceStyleService.appStyle.paleSilver,
              key: controller.imageSizeKey,
              child: TransitionToImage(
                  image: controller.imageList[controller.imageIndex]),
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
              top: 0,
              child: Container(
                child: PostImageTabBar(
                  length: controller.imageList.length,
                  imageWidth: controller.imageWidth,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}