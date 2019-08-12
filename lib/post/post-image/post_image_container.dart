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

  var url;

  List<Post> postList;

  bool loaded = false;

  List<AdvancedNetworkImage> imageList;

  double imageWidth;
  double imageHeight;

  PostImageController postImageController;

  PostContainerController postContainerController;

  PostImageContainerController({this.thePost});

  @override
  void initState() {
    getImages();

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
              postImageController.getImageWidth();
              postImageController.refresh();
            });
          },
        ));
      } else {
        imageList.add(AdvancedNetworkImage(thePost.imgUrlList[i]));
      }
    }
    postImageController = PostImageController(
        imageList: imageList,
        returnImageWidth: (width) {
          postContainerController = PostContainerController(
            thePost: thePost,
            imageWidth: width,
          );
          refresh();
        });
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
          controller.imageList != null
              ? PostImage(controller: controller.postImageController)
              : Container(),
          controller.postContainerController != null
              ? PostContainer(controller: controller.postContainerController)
              : Container(),
        ],
      ),
    );
  }
}
