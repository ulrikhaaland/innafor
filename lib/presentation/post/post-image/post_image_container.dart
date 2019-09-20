import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innafor/helper/helper.dart';
import 'package:innafor/model/post.dart';
import 'package:innafor/model/user.dart';
import 'package:innafor/presentation/base_controller.dart';
import 'package:innafor/presentation/base_view.dart';
import 'package:innafor/presentation/post/post-image/post_image.dart';
import 'package:innafor/presentation/post/post-image/post_video.dart';
import 'package:innafor/presentation/widgets/popup/snackbar.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:provider/provider.dart';
import '../post_container.dart';

class PostImageContainerController extends BaseController {
  final Post post;

  var url;

  List<Post> postList;

  bool loaded = false;

  List<AdvancedNetworkImage> imageList;

  final VoidCallback hasLoaded;

  final VoidCallback openReport;

  final VoidCallback onSave;

  double imageWidth;
  double imageHeight;

  PostImageController postImageController;

  bool preview;

  PostContainerController postContainerController;

  bool video = false;

  PostImageContainerController(
      {this.hasLoaded, this.post, this.openReport, this.onSave, this.preview});

  @override
  void initState() {
    // if (!preview) setContainerCtrlr();

    if (post.imgUrlList.isNotEmpty) getImages();
    super.initState();
  }

  void getImages() {
    imageList = <AdvancedNetworkImage>[];
    for (int i = 0; i < post.imgUrlList.length; i++) {
      if (i == 0) {
        imageList.add(AdvancedNetworkImage(
          post.imgUrlList[0],
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

              // if (!preview) setContainerCtrlr();

              refresh();

              postImageController.refresh();

              hasLoaded();
            });
          },
        ));
      } else {
        imageList.add(AdvancedNetworkImage(post.imgUrlList[i]));
      }
    }
    postImageController =
        PostImageController(imageList: imageList, preview: preview);

    refresh();
  }

  // setContainerCtrlr() {
  //   postContainerController = PostContainerController(
  //     post: post,
  //     imageWidth: 271.5977142857143,
  //     //  imageWidth,
  //   );
  // }
}

class PostImageContainer extends BaseView {
  final PostImageContainerController controller;

  PostImageContainer({this.controller});

  @override
  Widget build(BuildContext context) {
    controller.imageHeight = getContainerSize(
      key: controller.postImageController.imageSizeKey,
      width: false,
    );

    controller.imageWidth = getContainerSize(
      key: controller.postImageController.imageSizeKey,
      width: true,
    );

    if (controller.postContainerController == null)
      controller.postContainerController = PostContainerController(
        post: controller.post,
        imageWidth: 271.5977142857143,
        //  imageWidth,
      );

    return Flexible(
      fit: FlexFit.loose,
      child: Stack(
        children: <Widget>[
          // Responsible for loading the images
          Stack(
              children: controller.imageList
                  .map((img) => Container(
                        height: 0,
                        width: 0,
                        child: Image(
                          image: img,
                        ),
                      ))
                  .toList()),
          controller.video
              ? PostVideo(
                  controller: PostVideoController(),
                )
              : controller.imageList != null
                  ? PostImage(controller: controller.postImageController)
                  : Container(),
          if (!controller.preview) ...[
            controller.postContainerController != null
                ? PostContainer(
                    controller: controller.postContainerController,
                  )
                : Container(),
            Positioned(
              top: 30,
              right: 30,
              child: GestureDetector(
                onTap: () => controller.openReport(),
                child: Icon(
                  FontAwesomeIcons.ellipsisH,
                  color: Colors.white,
                  size: ServiceProvider
                      .instance.instanceStyleService.appStyle.iconSizeSmall,
                ),
              ),
            ),
            Positioned(
              top: 80,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  showSnackBar("Innlegget er lagret i dine bokmerker", context);
                  User user = Provider.of<User>(context);
                  user.docRef
                      .collection("bookmark")
                      .document(controller.post.id)
                      .setData({});
                },
                child: Icon(
                  FontAwesomeIcons.solidBookmark,
                  color: Colors.white,
                  size: ServiceProvider
                      .instance.instanceStyleService.appStyle.iconSizeSmall,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
