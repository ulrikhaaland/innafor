import 'dart:async';

import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:innafor/app-bar/innafor_app_bar.dart';
import 'package:innafor/objects/comment.dart';
import 'package:innafor/objects/post.dart';
import 'package:innafor/auth.dart';
import 'package:innafor/base_controller.dart';
import 'package:innafor/base_view.dart';
import 'package:innafor/objects/report_dialog_info.dart';
import 'package:innafor/objects/user.dart';
import 'package:innafor/post/post-comment/post_comment_container.dart';
import 'package:innafor/post/post-comment/post_new_comment.dart';
import 'package:innafor/post/post-image/post_image_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innafor/widgets/buttons/fab.dart';
import 'package:innafor/widgets/popup/main_dialog.dart';
import 'package:provider/provider.dart';
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

  User user;

  bool showShadowOverlay = false;

  bool showComments = false;

  double imgContainerWidth;

  FabController fabController;

  double deviceHeight;

  Widget x;

  PostPageController({this.auth});
  @override
  void initState() {
    fabController = FabController(
        showFab: false,
        onPressed: () {
          shadow(false);
          fabController.showFabAsMethod(false);
          _scaffoldKey.currentState
              .showBottomSheet((context) {
                return PostNewComment(
                  controller: PostNewCommentController(
                    user: user,
                    thePost: thePost,
                  ),
                );
              })
              .closed
              .then((v) {
                if (showShadowOverlay) {
                  shadow(false);
                }
                Timer(Duration(milliseconds: 170),
                    () => fabController.showFabAsMethod(true));
              });
        }
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => PostNewComment(
        //     controller:
        //         PostNewCommentController(userImage: user.profileImageWidget),
        //   ),
        // )),
        );
    setScrollListener();
    postList = <Post>[];
    getPost();
    super.initState();
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

  void setScrollListener() {
    scrollController.addListener(() {
      if ((scrollController.offset > 50 && showComments) &&
          !showShadowOverlay) {
        if (!fabController.showFab) {
          fabController.showFab = true;
          fabController.refresh();
        }
      } else {
        if (fabController.showFab) {
          fabController.showFab = false;
          fabController.refresh();
        }
      }
    });
  }

  void showReport(ReportDialogInfo reportInfo) {
    fabController.showFab = false;
    shadow(false);
    _scaffoldKey.currentState
        .showBottomSheet(
          (
            context,
          ) {
            return MainDialog(
              controller: MainDialogController(
                dialogContentType: DialogContentType.report,
                divide: true,
                onDone: () => shadow(true),
                reportDialogInfo: reportInfo,
              ),
            );
          },
        )
        .closed
        .then((v) {
          if (showComments)
            Timer(Duration(milliseconds: 170),
                () => fabController.showFabAsMethod(true));

          if (showShadowOverlay) shadow(false);
        });
  }

  setProfileImage() {
    user.profileImageWidget = x;
  }

  void getPost() async {
    QuerySnapshot postSnap =
        await Firestore.instance.collection("post").getDocuments();

    // Fetch posts
    postSnap.documents.forEach((postDoc) {
      Post post = Post(
          id: postDoc.documentID,
          message: postDoc.data["message"],
          imgUrlList: postDoc.data["img"],
          commentList: [],
          title: postDoc.data["title"],
          userName: postDoc.data["user_name"],
          userNameId: postDoc.data["user_name_id"],
          uid: postDoc.data["uid"],
          docRef: postDoc.reference);
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

    if (controller.user == null) controller.user = Provider.of<User>(context);

    if (controller.deviceHeight == null)
      controller.deviceHeight =
          ServiceProvider.instance.screenService.getHeight(context);

    controller.x = CircleAvatar(
      radius: ServiceProvider.instance.screenService
          .getWidthByPercentage(context, 7.5),
      backgroundColor: Colors.transparent,
      backgroundImage:
          AdvancedNetworkImage(controller.user.imageUrl, loadedCallback: () {
        controller.setProfileImage();
      }),
    );

    return Scaffold(
      key: controller._scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButton: Fab(
        controller: controller.fabController,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Stack(
          children: <Widget>[
            Positioned(left: 100, top: 300, child: controller.x),
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    height: controller.deviceHeight > 750
                        ? ServiceProvider.instance.screenService
                            .getHeightByPercentage(context, 90)
                        : ServiceProvider.instance.screenService
                            .getHeightByPercentage(context, 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        controller.deviceHeight > 750
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
                                    openReport: () =>
                                        controller.showReport(ReportDialogInfo(
                                          reportedByUser: controller.user,
                                          reportedUser: User(
                                              id: controller.thePost.uid,
                                              userName:
                                                  controller.thePost.userName),
                                          reportType: ReportType.post,
                                          id: controller.thePost.id,
                                        )),
                                    hasLoaded: () {
                                      if (controller
                                              .thePost.commentList.length >
                                          0) {
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
                  PostCommentContainer(
                    controller: PostCommentContainerController(
                      postPageController: controller,
                      show: (isShowing) => controller.showComments = isShowing,
                      user: controller.user,
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () => controller.shadow(true),
              child: controller.showShadowOverlay
                  ? Container(
                      height: 3000,
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
