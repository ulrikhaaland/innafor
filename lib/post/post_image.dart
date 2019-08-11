import 'dart:async';

import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:bss/objects/post.dart';
import 'package:bss/post/post_container.dart';
import 'package:bss/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helper.dart';

class PostImageController extends BaseController {
  final Post thePost;
  GlobalKey imageSizeKey = GlobalKey();

  var url;

  List<Post> postList;

  bool loaded = false;

  double imageWidth;
  PostImageController({this.thePost});

  void getImageWidth() {
    final RenderBox renderBoxRed =
        imageSizeKey.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;
    print(sizeRed.width);
    imageWidth = sizeRed.width;
    refresh();
  }
}

class PostImage extends BaseView {
  final PostImageController controller;

  PostImage({this.controller});
  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: getDefaultPadding(context) * 2,
              right: getDefaultPadding(context) * 2,
            ),
            child: controller.thePost != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      color: ServiceProvider
                          .instance.instanceStyleService.appStyle.paleSilver,
                      key: controller.imageSizeKey,
                      child: TransitionToImage(
                        image: AdvancedNetworkImage(
                          controller.thePost.imgUrlList[0],
                          loadedCallback: () {
                            controller.loaded = true;
                            Timer(Duration(milliseconds: 50), () {
                              controller.getImageWidth();
                              controller.refresh();
                            });
                          },
                        ),
                      ),
                    ))
                : Container(),
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
