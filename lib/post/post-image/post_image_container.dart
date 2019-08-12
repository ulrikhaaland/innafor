import 'dart:async';
import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:bss/objects/post.dart';
import 'package:bss/post/post-image/post_image.dart';
import 'package:bss/post/post_container.dart';
import 'package:bss/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

import '../../helper.dart';

class PostImageContainerController extends BaseController {
  final Post thePost;
  GlobalKey imageSizeKey = GlobalKey();

  var url;

  List<Post> postList;

  bool loaded = false;

  List<AdvancedNetworkImage> imageList = <AdvancedNetworkImage>[];

  double imageWidth;

  PostImageContainerController({this.thePost});

  @override
  void initState() {
    getImages();
    super.initState();
  }

  void getImages() {
    for (int i = 0; i < thePost.imgUrlList.length; i++) {
      if (i == 0) {
        imageList.add(AdvancedNetworkImage(
          thePost.imgUrlList[0],
          loadedCallback: () {
            loaded = true;
            Timer(Duration(milliseconds: 50), () {
              getImageWidth();
              refresh();
            });
          },
        ));
      } else {
        imageList.add(AdvancedNetworkImage(thePost.imgUrlList[i]));
      }
    }
  }

  void getImageWidth() {
    final RenderBox renderBoxRed =
        imageSizeKey.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;
    print(sizeRed.width);
    imageWidth = sizeRed.width;
    refresh();
  }
}

class PostImageContainer extends BaseView {
  final PostImageContainerController controller;

  PostImageContainer({this.controller});
  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Stack(
        children: <Widget>[
          PostImage(
            controller: PostImageController(
              imageList: controller.imageList,
              imageSizeKey: controller.imageSizeKey,
            ),
          ),
          controller.imageWidth != null
              ? PostContainer(
                  controller: PostContainerController(
                      thePost: controller.thePost,
                      imageWidth: controller.imageWidth),
                )
              : Container(),
        ],
      ),
    );
  }
}
