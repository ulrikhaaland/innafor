import 'dart:async';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:innafor/helper/auth.dart';
import 'package:innafor/helper/helper.dart';
import 'package:innafor/model/comment.dart';
import 'package:innafor/model/post.dart';
import 'package:innafor/model/report_dialog_info.dart';
import 'package:innafor/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innafor/presentation/app-bar/innafor_app_bar.dart';
import 'package:innafor/presentation/base_controller.dart';
import 'package:innafor/presentation/base_view.dart';
import 'package:innafor/presentation/post/post-comment/post_comment.dart';
import 'package:innafor/presentation/post/post-comment/post_comment_container.dart';
import 'package:innafor/presentation/post/post-comment/post_new_comment.dart';
import 'package:innafor/presentation/post/post-image/post_image_container.dart';
import 'package:innafor/presentation/post/post-indicator/post_indicator.dart';
import 'package:innafor/presentation/post/post_utilities.dart';
import 'package:innafor/presentation/widgets/buttons/fab.dart';
import 'package:innafor/presentation/widgets/popup/bottom_sheet.dart';
import 'package:innafor/presentation/widgets/popup/main_dialog.dart';
import 'package:innafor/provider/comment_provider.dart';
import 'package:innafor/provider/crud_provider.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:provider/provider.dart';

class PostPageController extends BaseController
    implements PostActionController {
  GlobalKey imageSizeKey = GlobalKey();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController scrollController = ScrollController();

  var url;

  List<Post> postList;

  final Post post;

  List<Comment> comments;

  bool loaded = false;

  Future<bool> canDispose = Future.value(true);

  bool showShadowOverlay = false;

  bool showComments = false;

  double imgContainerWidth;

  FabController fabController;

  PostCommentContainerController containerController;

  double deviceHeight;

  InnaforBottomSheetController bottomSheetController;

  Widget x;

  User user;

  PostPageController({@required this.post, this.comments});
  @override
  void initState() {
    containerController = PostCommentContainerController(
      actionController: this,
      postPageController: this,
      show: (isShowing) {
        showComments = isShowing;
        bottomSheetController.showComments = isShowing;
      },
    );
    fabController = FabController(
        iconData: FontAwesomeIcons.plus,
        showFab: false,
        onPressed: () {
          bottomSheetController.showBottomSheet(
            content: PostNewComment(
              controller: PostNewCommentController(
                post: post,
                newCommentType: NewCommentType.post,
                parentController: this,
                user: user,
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

    setScrollListener();

    super.initState();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    scaffoldKey.currentState?.dispose();
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

  @override
  Future<void> deleteComment(Comment comment, {CommentType type}) {
    comments.remove(comment);

    Navigator.of(context).pop();

    if (comments.isEmpty) {
      containerController.showComments = false;
    }

    refresh();

    return CommentProvider().delete(comment, comments);
  }

  @override
  Future<void> saveComment(Comment comment) {
    comments.add(comment);

    String childId;
    String isChildOfId;

    refresh();

    return CommentProvider()
        .saveComment(comment: comment, postRef: post.docRef)
        .then((_) {
      if (comment.isChildOfId != null) {
        childId = comment.id;
        isChildOfId = comment.isChildOfId;
        while (isChildOfId != null) {
          Comment parent =
              comments.firstWhere((c) => c.id == isChildOfId, orElse: () {
            return;
          });
          parent.hierarchy.add(childId);
          if (parent.isChildOfId != null) {
            isChildOfId = parent.isChildOfId;
            childId = parent.id;
          } else {
            isChildOfId = null;
          }
        }
      }
    });
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

    controller.user = Provider.of<User>(context);

    controller.x = CircleAvatar(
      radius: ServiceProvider.instance.screenService
          .getWidthByPercentage(context, 7.5),
      backgroundColor:
          ServiceProvider.instance.instanceStyleService.appStyle.mimiPink,
      backgroundImage: controller.user.imageUrl != null
          ? AdvancedNetworkImage(controller.user.imageUrl, loadedCallback: () {
              controller.setProfileImage();
            })
          : null,
      child: Icon(
        FontAwesomeIcons.userSecret,
        color: ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
        size: ServiceProvider
            .instance.instanceStyleService.appStyle.iconSizeStandard,
      ),
    );

    if (controller.user.imageUrl == null) {
      controller.setProfileImage();
    }

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
                            : Container(
                                height: ServiceProvider.instance.screenService
                                    .getHeightByPercentage(context, 5),
                              ),
                        controller.post != null
                            ? PostImageContainer(
                                controller: PostImageContainerController(
                                    post: controller.post,
                                    openReport: () {
                                      DialogContentType dialogType;
                                      if (controller.post.uid !=
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
                                                  id: controller.post.uid,
                                                  userName:
                                                      controller.post.userName),
                                              reportType: ReportType.post,
                                              id: controller.post.id,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    hasLoaded: () {
                                      if (controller.comments.length > 0) {
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
                        PostIndicator(
                          postId: controller.post.id,
                        ),
                      ],
                    ),
                  ),
                  if (controller.post != null) ...[
                    PostCommentContainer(
                        controller: controller.containerController),
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
