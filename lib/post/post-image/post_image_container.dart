import 'dart:async';
import 'package:innafor/base_controller.dart';
import 'package:innafor/base_view.dart';
import 'package:innafor/objects/post.dart';
import 'package:innafor/post/post-image/post_image.dart';
import 'package:innafor/post/post-image/post_video.dart';
import 'package:innafor/post/post_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

import '../../helper.dart';

class PostImageContainerController extends BaseController {
  final Post thePost;

  var url;

  List<Post> postList;

  bool loaded = false;

  List<AdvancedNetworkImage> imageList;

  final VoidCallback hasLoaded;

  double imageWidth;
  double imageHeight;

  PostImageController postImageController;

  PostContainerController postContainerController;

  bool video = false;

  PostImageContainerController({this.hasLoaded, this.thePost});

  @override
  void initState() {
    if (thePost.imgUrlList.isNotEmpty) getImages();

    super.initState();
  }

  void getImages() {
    imageList = <AdvancedNetworkImage>[];
    for (int i = 0; i < thePost.imgUrlList.length; i++) {
      if (i == 0) {
        imageList.add(AdvancedNetworkImage(
          thePost.imgUrlList[0],
          loadedCallback: () {
            loaded = true;
            Timer(Duration(milliseconds: 50), () {
              imageHeight = getContainerSize(
                key: postImageController.imageSizeKey,
                width: false,
              );

              imageWidth = getContainerSize(
                key: postImageController.imageSizeKey,
                width: true,
              );

              postImageController.imageWidth = imageWidth;
              postImageController.imageHeight = imageHeight;

              setContainerCtrlr();

              refresh();

              postImageController.refresh();

              hasLoaded();
            });
          },
        ));
      } else {
        imageList.add(AdvancedNetworkImage(thePost.imgUrlList[i]));
      }
    }
    postImageController = PostImageController(
      imageList: imageList,
    );

    refresh();
  }

  setContainerCtrlr() {
    postContainerController = PostContainerController(
      thePost: thePost,
      imageWidth: imageWidth,
    );
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
          controller.video
              ? PostVideo(
                  controller: PostVideoController(),
                )
              : controller.imageList != null
                  ? PostImage(controller: controller.postImageController)
                  : Container(),
          controller.postContainerController != null
              ? PostContainer(
                  controller: controller.postContainerController,
                )
              : Container(),
        ],
      ),
    );
  }
}
