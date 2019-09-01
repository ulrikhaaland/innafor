import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innafor/base_controller.dart';
import 'package:innafor/base_view.dart';
import 'package:innafor/helper.dart';
import 'package:innafor/objects/comment.dart';
import 'package:innafor/objects/user.dart';
import 'package:innafor/post/post-comment/post_comment.dart';
import 'package:innafor/post/post-comment/post_new_comment.dart';
import 'package:innafor/post/post_page.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:innafor/widgets/buttons/fab.dart';
import 'package:innafor/widgets/popup/bottom_sheet.dart';

class PostCommentPageController extends BaseController {
  Comment comment;

  final User user;

  FabController fabController;

  final PostPageController postPageController;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool shadowOverlay = false;

  InnaforBottomSheetController bottomSheetController;

  final String documentPath;

  PostCommentPageController({
    this.comment,
    this.user,
    this.postPageController,
    this.documentPath,
  });

  @override
  void initState() {
    // Order comments by likes and replies
    if (comment.children.length > 1) {
      comment.children.forEach((c) =>
          c.sort = (c.children.length * 1) + (c.favoriteIds.length * 0.6));
      comment.children.sort((a, b) => b.sort.compareTo(a.sort));
    }
    fabController = FabController(
        showFab: true,
        iconData: FontAwesomeIcons.reply,
        onPressed: () {
          bottomSheetController.showBottomSheet(
            content: PostNewComment(
              controller: PostNewCommentController(
                user: user,
                thePost: postPageController.thePost,
                newCommentType: NewCommentType.comment,
                comment: comment,
              ),
            ),
          );
        });
    bottomSheetController = InnaforBottomSheetController(
      scaffoldKey: scaffoldKey,
      fabController: fabController,
      context: context,
      withShadowOverlay: true,
      showComments: true,
    );

    super.initState();
  }

  @override
  void dispose() {
    scaffoldKey.currentState.dispose();
    super.dispose();
  }
}

class PostCommentPage extends BaseView {
  final PostCommentPageController controller;

  PostCommentPage({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    Widget commentWidget = PostComment(
      controller: PostCommentController(
        comment: controller.comment,
        commentType: CommentType.comment,
        user: controller.user,
        postPageController: controller.postPageController,
      ),
    );
    return Scaffold(
      key: controller.scaffoldKey,
      floatingActionButton: Fab(
        controller: controller.fabController,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: ServiceProvider
          .instance.instanceStyleService.appStyle.backgroundColor,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: ServiceProvider.instance.screenService
                        .getHeightByPercentage(context, 5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: getDefaultPadding(context) * 4),
                          child: Icon(Icons.arrow_back_ios),
                        ),
                      ),
                      Text(
                        "Kommentar",
                        style: ServiceProvider.instance.instanceStyleService
                            .appStyle.secondaryTitle,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: getDefaultPadding(context) * 4),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: ServiceProvider.instance.screenService
                        .getHeightByPercentage(context, 2.5),
                  ),
                  commentWidget,
                  if (controller.comment.children.length > 0)
                    Column(
                      children: controller.comment.children.map((c) {
                        return PostComment(
                          controller: PostCommentController(
                              answerToUserNameId: controller.comment.userNameId,
                              postPageController: controller.postPageController,
                              comment: c,
                              user: controller.user,
                              commentType: CommentType.response,
                              parentId: controller.comment.id),
                        );
                      }).toList(),
                    )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => null,
            child: controller.shadowOverlay
                ? Container(
                    height: 3000,
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
