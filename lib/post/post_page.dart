import 'dart:async';
import 'package:bss/app-bar/innafor_app_bar.dart';
import 'package:bss/objects/post.dart';
import 'package:bss/auth.dart';
import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:bss/post/post-image/post_image_container.dart';
import 'package:bss/widgets/circular_progress_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  var url;

  List<Post> postList;

  Post thePost;

  bool loaded = false;

  bool video = true;

  double imgContainerWidth;

  PostPageController({this.auth});
  @override
  void initState() {
    super.initState();
    postList = <Post>[];

    getPost();
  }

  void getPost() async {
    QuerySnapshot qSnap =
        await Firestore.instance.collection("post").getDocuments();

    qSnap.documents.forEach((d) => postList.add(Post(
        message: d.data["message"],
        imgUrlList: d.data["img"],
        commentCount: d.data["comments"],
        title: d.data["title"])));

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          // InnaforAppBar(
          //   controller: InnaforAppBarController(auth: controller.auth),
          // ),
          controller.thePost != null
              ? PostImageContainer(
                  controller: PostImageContainerController(
                    thePost: controller.thePost,
                  ),
                )
              : Container(),
          // SingleChildScrollView(
          //   child: Column(
          //     children: <Widget>[
          //       RatingBar(
          //         itemPadding: EdgeInsets.only(left: 8, right: 8, top: 8),
          //         onRatingUpdate: (r) => print(r),
          //         allowHalfRating: true,
          //         ratingWidget: RatingWidget(
          //             empty: Icon(
          //               FontAwesomeIcons.star,
          //               color: ServiceProvider.instance.instanceStyleService
          //                   .appStyle.inactiveIconColor,
          //             ),
          //             full: Icon(
          //               FontAwesomeIcons.solidStar,
          //               color: ServiceProvider.instance.instanceStyleService
          //                   .appStyle.mountbattenPink,
          //             ),
          //             half: Icon(
          //               FontAwesomeIcons.starHalfAlt,
          //               color: ServiceProvider.instance.instanceStyleService
          //                   .appStyle.mountbattenPink,
          //             )),
          //       ),
          //     ],
          //   ),
          // ),
          // Container(
          //   height: ServiceProvider.instance.screenService
          //       .getHeightByPercentage(context, 2.5),
          // )
        ],
      ),
    );
  }
}
