import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:bss/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

import '../../helper.dart';

class PostImageController extends BaseController {
  final GlobalKey imageSizeKey;

  final void Function(double imageWidth) returnImageWidth;

  final List<AdvancedNetworkImage> imageList;

  int imageIndex = 0;

  PostImageController(
      {this.returnImageWidth, this.imageList, this.imageSizeKey});
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
          GestureDetector(
            onTap: () {
              if (controller.imageIndex + 1 < controller.imageList.length) {
                controller.imageIndex++;
              } else {
                controller.imageIndex = 0;
              }
              controller.refresh();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                color: ServiceProvider
                    .instance.instanceStyleService.appStyle.paleSilver,
                key: controller.imageSizeKey,
                child: TransitionToImage(
                    image: controller.imageList[controller.imageIndex]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
