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
import 'package:innafor/widgets/popup/bottom_sheet.dart';
import 'package:innafor/widgets/popup/main_dialog.dart';
import 'package:provider/provider.dart';
import '../service/service_provider.dart';
import '../helper.dart';

class PostPageController extends BaseController {
  final BaseAuth auth;

  GlobalKey imageSizeKey = GlobalKey();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController scrollController = ScrollController();

  var url;

  List<Post> postList;

  Post thePost;

  bool loaded = false;

  final User user;

  Future<bool> canDispose = Future.value(true);

  bool showShadowOverlay = false;

  bool showComments = false;

  double imgContainerWidth;

  FabController fabController;

  double deviceHeight;

  InnaforBottomSheetController bottomSheetController;

  PostCommentContainerController commentContainerController;

  Widget x;

  PostPageController({this.auth, this.user});
  @override
  void initState() {
    fabController = FabController(
        iconData: FontAwesomeIcons.plus,
        showFab: false,
        onPressed: () {
          bottomSheetController.showBottomSheet(
            content: PostNewComment(
              controller: PostNewCommentController(
                user: user,
                thePost: thePost,
                newCommentType: NewCommentType.post,
                parentController: this,
              ),
            ),
          );
        });
    bottomSheetController = InnaforBottomSheetController(
      scaffoldKey: scaffoldKey,
      fabController: fabController,
      context: context,
      withShadowOverlay: true,
      showComments: showComments,
    );

    commentContainerController = PostCommentContainerController(
      postPageController: this,
      show: (isShowing) {
        showComments = isShowing;
        bottomSheetController.showComments = isShowing;
      },
      user: user,
    );

    setScrollListener();
    postList = <Post>[];
    getPost();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    scaffoldKey.currentState.dispose();
    super.dispose();
  }

  void setScrollListener() {
    scrollController.addListener(() {
      if ((scrollController.offset > 50 && showComments) &&
          !showShadowOverlay) {
        if (!fabController.showFab) {
          bottomSheetController.showComments = true;
          fabController.showFab = true;
          fabController.setState(() {});
        }
      } else {
        if (fabController.showFab) {
          bottomSheetController.showComments = false;
          fabController.showFab = false;
          fabController.setState(() {});
        }
      }
    });
  }

  Future<bool> allowDispose() {
    canDispose = Future.value(false);
    Timer(
      Duration(milliseconds: 5),
      () => canDispose = Future.value(true),
    );
    return canDispose;
  }

  setProfileImage() {
    user.profileImageWidget = x;
  }

  void getPost() async {
    QuerySnapshot postSnap =
        await Firestore.instance.collection("post").getDocuments();

    // Fetch posts
    postSnap.documents.forEach((postDoc) async {
      Post post = Post(
          id: postDoc.documentID,
          message: postDoc.data["message"],
          imgUrlList: postDoc.data["img"],
          commentList: <Comment>[],
          title: postDoc.data["title"],
          userName: postDoc.data["user_name"],
          userNameId: postDoc.data["user_name_id"],
          uid: postDoc.data["uid"],
          docRef: postDoc.reference);

      // Fetch comments for each post
      postList.add(post);
      post.commentList =
          await getComments(path: post.docRef.path + "/comments", post: post);
    });
    thePost = postList[0];
  }

  Future<List<Comment>> getComments({String path, Post post}) async {
    List<Comment> commentList = <Comment>[];
    QuerySnapshot qSnap =
        await Firestore.instance.collection(path).getDocuments();
    if (qSnap.documents.isNotEmpty) {
      qSnap.documents.forEach((doc) {
        Comment comment = Comment(
            id: doc.documentID,
            text: doc.data["text"],
            timestamp: doc.data["timestamp"].toDate(),
            favoriteIds: <String>[],
            ancestorIds: <String>[],
            isChildOfId: doc.data["is_child_of_id"],
            userImageUrl: doc.data["user_image_url"],
            userName: doc.data["user_name"],
            uid: doc.data["uid"],
            userNameId: doc.data["user_name_id"],
            docRef: doc.reference);
        commentList.add(comment);
        // Get user id's for comment favorites
        doc.reference
            .collection("favorites")
            .getDocuments()
            .then((favoriteColl) {
          favoriteColl.documents.forEach(
              (favorite) => comment.favoriteIds.add(favorite.documentID));
        });
      });

      commentList.forEach((c) => c.sort =
          (commentList.where((child) => child.isChildOfId == c.id).length * 1) +
              (c.favoriteIds.length * 0.6));
      commentList.sort((a, b) => b.sort.compareTo(a.sort));

      setState(() {});
      return commentList;
    } else {
      setState(() {});
      return commentList;
    }
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

    if (controller.deviceHeight == null)
      controller.deviceHeight =
          ServiceProvider.instance.screenService.getHeight(context);

    controller.x = CircleAvatar(
      radius: ServiceProvider.instance.screenService
          .getWidthByPercentage(context, 7.5),
      backgroundColor:
          ServiceProvider.instance.instanceStyleService.appStyle.mimiPink,
      backgroundImage: controller.user?.imageUrl != null
          ? AdvancedNetworkImage(controller.user.imageUrl, loadedCallback: () {
              controller.setProfileImage();
            })
          : controller.setProfileImage(),
      child: Icon(
        FontAwesomeIcons.userSecret,
        color: ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
        size: ServiceProvider
            .instance.instanceStyleService.appStyle.iconSizeStandard,
      ),
    );

    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButton: Fab(
        controller: controller.fabController,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Stack(
          children: <Widget>[
            if (controller.user.imageUrl != null)
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
                                    openReport: () {
                                      DialogContentType dialogType;
                                      if (controller.thePost.uid !=
                                          controller.user.id) {
                                        dialogType = DialogContentType.report;
                                      } else {
                                        dialogType = DialogContentType.isOwner;
                                      }
                                      controller.bottomSheetController
                                          .showBottomSheet(
                                        content: MainDialog(
                                          controller: MainDialogController(
                                            dialogContentType: dialogType,
                                            divide: true,
                                            reportDialogInfo: ReportDialogInfo(
                                              reportedByUser: controller.user,
                                              reportedUser: User(
                                                  id: controller.thePost.uid,
                                                  userName: controller
                                                      .thePost.userName),
                                              reportType: ReportType.post,
                                              id: controller.thePost.id,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
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
                          onRatingUpdate: (r) {
                            print(r);
                          },
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
                  if (controller.thePost != null) ...[
                    Container(
                      height: getDefaultPadding(context) * 4,
                    ),
                    PostCommentContainer(
                      controller: controller.commentContainerController,
                    ),
                  ],
                ],
              ),
            ),
            InnaforBottomSheet(
              controller: controller.bottomSheetController,
            ),
          ],
        ),
      ),
    );
  }
}
