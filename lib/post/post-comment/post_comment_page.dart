import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innafor/base_controller.dart';
import 'package:innafor/base_view.dart';
import 'package:innafor/helper.dart';
import 'package:innafor/objects/comment.dart';
import 'package:innafor/objects/user.dart';
import 'package:innafor/post/post-comment/post_comment.dart';
import 'package:innafor/post/post_page.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:innafor/widgets/buttons/fab.dart';

class PostCommentPageController extends BaseController {
  Comment comment;

  final User user;

  FabController fabController;

  final PostPageController postPageController;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool shadowOverlay = false;

  PostCommentPageController({
    this.comment,
    this.user,
    this.postPageController,
  });

  @override
  void initState() {
    fabController = FabController(
        showFab: true, iconData: FontAwesomeIcons.reply, onPressed: () => null);
    postPageController.theComment.add(comment);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _scaffoldKey.currentState.dispose();
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
      key: controller._scaffoldKey,
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
                              commentType: CommentType.response
                              // onDive: () {
                              //   controller.comment = c;
                              //   controller.commentHierarchy.add(c);
                              //   controller.refresh();
                              // }
                              ),
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
