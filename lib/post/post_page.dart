import 'package:flutter/material.dart' as prefix0;
import 'package:innafor/app-bar/innafor_app_bar.dart';
import 'package:innafor/objects/comment.dart';
import 'package:innafor/objects/post.dart';
import 'package:innafor/auth.dart';
import 'package:innafor/base_controller.dart';
import 'package:innafor/base_view.dart';
import 'package:innafor/objects/user.dart';
import 'package:innafor/post/post-comment/post_comment.dart';
import 'package:innafor/post/post-image/post_image_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innafor/widgets/dialogs/report_dialog.dart';
import '../service/service_provider.dart';
import '../helper.dart';

class PostPageController extends BaseController {
  final BaseAuth auth;

  GlobalKey imageSizeKey = GlobalKey();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController scrollController = ScrollController();

  var url;

  List<Post> postList;

  Post thePost;

  bool loaded = false;

  bool showShadowOverlay = false;

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

  void shadow(bool pop) {
    showShadowOverlay = !showShadowOverlay;
    if (pop) Navigator.pop(context);
    refresh();
  }

  void getPost() async {
    QuerySnapshot postSnap =
        await Firestore.instance.collection("post").getDocuments();

    // Fetch posts
    postSnap.documents.forEach((postDoc) {
      Post post = Post(
          message: postDoc.data["message"],
          imgUrlList: postDoc.data["img"],
          commentCount: postDoc.data["comments"],
          commentList: [],
          title: postDoc.data["title"]);
      postList.add(post);

      // Fetch comments for each post
      Firestore.instance
          .collection("post/${postDoc.documentID}/comments")
          .getDocuments()
          .then((commentDoc) {
        List<Comment> isChild = <Comment>[];

        // Iterate through all documents and convert data into Comment objects
        commentDoc.documents.forEach((cd) {
          Comment comment = Comment(
              id: cd.documentID,
              text: cd.data["text"],
              timestamp: cd.data["timestamp"].toDate(),
              commentCount: cd.data["comment_count"],
              favoriteIds: <String>[],
              children: <Comment>[],
              isChildOfId: cd.data["is_child_of_id"] ?? "0",
              userImageUrl: cd.data["user_image_url"],
              userName: cd.data["user_name"],
              uid: cd.data["uid"],
              docRef: cd.reference);
          print(cd.reference.toString());
          // Get user id's for comment favorites
          cd.reference
              .collection("favorites")
              .getDocuments()
              .then((favoriteColl) {
            favoriteColl.documents.forEach(
                (favorite) => comment.favoriteIds.add(favorite.documentID));
          });

          // Seperate comments that is a child or not into different 2 lists
          comment.isChildOfId == "0"
              ? post.commentList.add(comment)
              : isChild.add(comment);
        });

        // add child comments to correct parent
        post.commentList.forEach((parent) {
          isChild.forEach((child) {
            if (parent.id == child.isChildOfId) {
              parent.children.add(child);
            }
          });
        });
        post.commentList
            .forEach((c) => c.sort = c.children.length + c.favoriteIds.length);
        post.commentList.sort((a, b) => b.sort.compareTo(a.sort));
        refresh();
      });
    });
    thePost = postList[0];
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
      key: controller._scaffoldKey,
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
                  if (controller.thePost.commentList.length > 0)
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
                                    : "Vis kommentarer",
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
                    Column(
                      children: controller.thePost.commentList
                          .map((c) => PostComment(
                                controller: PostCommentController(
                                    comment: c,
                                    showBottomSheet: () {
                                      controller.shadow(false);
                                      controller._scaffoldKey.currentState
                                          .showBottomSheet(
                                        (
                                          context,
                                        ) {
                                          return ReportDialog(
                                            controller: ReportDialogController(
                                              userInView: User(
                                                name: c.userName,
                                                id: c.uid,
                                              ),
                                              comment: c,
                                              onDone: () =>
                                                  controller.shadow(true),
                                            ),
                                          );
                                        },
                                      );
                                    }),
                              ))
                          .toList(),
                    ),
                    // PostComment(
                    //   controller: PostCommentController(
                    //     comment: controller.thePost.commentList[0],
                    //   ),
                    // ),
                    Container(
                      height: ServiceProvider.instance.screenService
                          .getHeightByPercentage(context, 5),
                    ),
                  ],
                ],
              ),
            ),
            GestureDetector(
              onTap: () => controller.shadow(true),
              child: controller.showShadowOverlay
                  ? Container(
                      height: 10000,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
