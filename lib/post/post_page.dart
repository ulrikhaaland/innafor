import 'dart:async';
import 'package:bss/app-bar/innafor_app_bar.dart';
import 'package:bss/objects/comment.dart';
import 'package:bss/objects/post.dart';
import 'package:bss/auth.dart';
import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:bss/post/post-comment/post_comment.dart';
import 'package:bss/post/post-image/post_image_container.dart';
import 'package:bss/widgets/circular_progress_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import '../service/service_provider.dart';
import '../helper.dart';

class PostPageController extends BaseController {
  final BaseAuth auth;

  GlobalKey imageSizeKey = GlobalKey();

  ScrollController scrollController = ScrollController();

  var url;

  List<Post> postList;

  Post thePost;

  bool loaded = false;

  bool showComments = false;

  double imgContainerWidth;

  PostPageController({this.auth});
  @override
  void initState() {
    super.initState();
    postList = <Post>[];
    // SystemChrome.setEnabledSystemUIOverlays([]);
    getPost();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void getPost() async {
    QuerySnapshot postSnap =
        await Firestore.instance.collection("post").getDocuments();

    postSnap.documents.forEach((d) {
      Post post = Post(
          message: d.data["message"],
          imgUrlList: d.data["img"],
          commentCount: d.data["comments"],
          commentList: [],
          title: d.data["title"]);
      postList.add(post);

      Firestore.instance
          .collection("post/$d/comments")
          .getDocuments()
          .then((commentSnap) {
        commentSnap.documents.forEach((cd) {
          post.commentList.add(Comment(
            text: cd.data["text"],
            timestamp: cd.data["timestamp"],
            commentCount: cd.data["comment_count"],
            favoriteCount: cd.data["favorite_count"],
          ));
        });
      });
    });
    thePost = postList[0];

    refresh();
  }
}

class PostPage extends BaseView {
  final PostPageController controller;

  final String category = "Ingen valgt";

  PostPage({
    this.controller,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();
    double deviceHeight =
        ServiceProvider.instance.screenService.getHeight(context);
    print(deviceHeight);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    height: deviceHeight > 750
                        ? ServiceProvider.instance.screenService
                            .getHeightByPercentage(context, 90)
                        : ServiceProvider.instance.screenService
                            .getHeightByPercentage(context, 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        deviceHeight > 750
                            ? Container(
                                height: ServiceProvider.instance.screenService
                                    .getHeightByPercentage(context, 2.5),
                              )
                            : Container(),
                        InnaforAppBar(
                          controller:
                              InnaforAppBarController(auth: controller.auth),
                        ),
                        controller.thePost != null
                            ? PostImageContainer(
                                controller: PostImageContainerController(
                                    thePost: controller.thePost,
                                    hasLoaded: () {
                                      if (controller.thePost.commentCount > 0) {
                                        scrollScreen(
                                          height: 300,
                                          controller:
                                              controller.scrollController,
                                          timeBeforeAction: 500,
                                        );
                                      }
                                    }),
                              )
                            : Container(),
                        RatingBar(
                          itemPadding:
                              EdgeInsets.only(left: 8, right: 8, top: 8),
                          onRatingUpdate: (r) => print(r),
                          allowHalfRating: true,
                          ratingWidget: RatingWidget(
                              empty: Icon(
                                FontAwesomeIcons.star,
                                color: ServiceProvider
                                    .instance
                                    .instanceStyleService
                                    .appStyle
                                    .inactiveIconColor,
                              ),
                              full: Icon(
                                FontAwesomeIcons.solidStar,
                                color: ServiceProvider
                                    .instance
                                    .instanceStyleService
                                    .appStyle
                                    .mountbattenPink,
                              ),
                              half: Icon(
                                FontAwesomeIcons.starHalfAlt,
                                color: ServiceProvider
                                    .instance
                                    .instanceStyleService
                                    .appStyle
                                    .mountbattenPink,
                              )),
                        ),
                      ],
                    ),
                  ),
                  if (controller.thePost.commentCount > 0)
                    GestureDetector(
                      onTap: () {
                        double height;
                        controller.showComments = !controller.showComments;

                        controller.refresh();
                        if (controller.showComments) {
                          deviceHeight > 750
                              ? height = ServiceProvider.instance.screenService
                                  .getHeightByPercentage(context, 85)
                              : height = ServiceProvider.instance.screenService
                                  .getHeightByPercentage(context, 100);
                        } else {
                          height = 0;
                        }
                        scrollScreen(
                            height: height,
                            controller: controller.scrollController,
                            timeBeforeAction: 100);
                      },
                      child: Card(
                        color: ServiceProvider
                            .instance.instanceStyleService.appStyle.leBleu,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Container(
                          height: ServiceProvider.instance.screenService
                              .getHeightByPercentage(context, 5),
                          width: ServiceProvider.instance.screenService
                              .getWidthByPercentage(context, 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                controller.showComments
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              Text(
                                controller.showComments
                                    ? "Skjul kommentarer"
                                    : "Se kommentarer",
                                style: ServiceProvider.instance
                                    .instanceStyleService.appStyle.body1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    Container(),
                  if (controller.showComments) ...[
                    PostComment(
                      controller: PostCommentController(),
                    ),
                    Container(
                      height: ServiceProvider.instance.screenService
                          .getHeightByPercentage(context, 5),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
