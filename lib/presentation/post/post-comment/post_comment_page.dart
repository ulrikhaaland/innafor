import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innafor/helper/helper.dart';
import 'package:innafor/model/comment.dart';
import 'package:innafor/model/user.dart';
import 'package:innafor/presentation/base_controller.dart';
import 'package:innafor/presentation/base_view.dart';
import 'package:innafor/presentation/post/post-comment/post_comment.dart';
import 'package:innafor/presentation/post/post-comment/post_new_comment.dart';
import 'package:innafor/presentation/widgets/buttons/fab.dart';
import 'package:innafor/presentation/widgets/popup/bottom_sheet.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:flutter/material.dart';

import '../post_page.dart';
import '../post_utilities.dart';

class PostCommentPageController extends BaseController
    implements PostActionController {
  Comment comment;

  List<Comment> children;

  final User user;

  FabController fabController;

  final PostPageController postPageController;

  final PostActionController actionController;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool shadowOverlay = false;

  InnaforBottomSheetController bottomSheetController;

  PostCommentPageController({
    this.comment,
    this.user,
    this.postPageController,
    this.actionController,
  });

  @override
  void initState() {
    children = postPageController.comments
        .where((c) => c.isChildOfId == comment.id)
        .toList();
    fabController = FabController(
        showFab: true,
        iconData: FontAwesomeIcons.reply,
        onPressed: () {
          bottomSheetController.showBottomSheet(
            content: PostNewComment(
              controller: PostNewCommentController(
                user: user,
                post: postPageController.post,
                newCommentType: NewCommentType.comment,
                comment: comment,
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
      showComments: true,
    );

    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      scaffoldKey.currentState?.dispose();
      super.dispose();
    }
  }

  @override
  Future<void> saveComment(Comment comment) {
    return actionController.saveComment(comment).then((_) {
      setState(() {
        children.add(comment);
      });
    });
  }

  @override
  Future<void> deleteComment(Comment comment, {CommentType type}) {
    return actionController.deleteComment(comment).then((_) {
      if (type == CommentType.comment) {
        Navigator.of(context).pop();
      } else {
        setState(() {
          children.remove(comment);
        });
      }
    });
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
        actionController: controller.actionController,
        comment: controller.comment,
        commentType: CommentType.comment,
        user: controller.user,
        postPageController: controller.postPageController,
        parentController: this.controller,
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
                      onTap: () async {
                        if (mounted) {
                          await controller.postPageController.allowDispose();

                          Navigator.pop(context);
                        }
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
                Container(
                  width: ServiceProvider.instance.screenService
                      .getWidthByPercentage(context, 93),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: controller.children.length,
                    itemBuilder: (context, index) {
                      Comment c = controller.children[index];

                      return PostComment(
                        key: Key(c.id),
                        controller: PostCommentController(
                          actionController: controller.actionController,
                          parentController: controller,
                          answerToUserNameId: controller.comment.userNameId,
                          postPageController: controller.postPageController,
                          comment: c,
                          user: controller.user,
                          commentType: CommentType.response,
                          parentId: controller.comment.id,
                        ),
                      );
                    },
                  ),
                ),
                // Column(
                //   children: controller.postPageController.comments
                //       .where((c) => c.isChildOfId == controller.comment.id)
                //       .map((c) {
                //     return PostComment(
                //       key: Key(c.id),
                //       controller: PostCommentController(
                //         actionController: controller.actionController,
                //         parentController: controller,
                //         answerToUserNameId: controller.comment.userNameId,
                //         postPageController: controller.postPageController,
                //         comment: c,
                //         user: controller.user,
                //         commentType: CommentType.response,
                //         parentId: controller.comment.id,
                //       ),
                //     );
                //   }).toList(),
                // )
              ],
            ),
          ),
          InnaforBottomSheet(
            controller: controller.bottomSheetController,
          ),
        ],
      ),
    );
  }
}
