import 'package:flutter/material.dart';
import 'package:innafor/base_controller.dart';
import 'package:innafor/base_view.dart';
import 'package:innafor/objects/post.dart';
import 'package:innafor/objects/report_dialog_info.dart';
import 'package:innafor/objects/user.dart';
import 'package:innafor/post/post_page.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:provider/provider.dart';
import 'package:innafor/objects/comment.dart';

import '../../helper.dart';
import 'post_comment.dart';

class PostCommentContainerController extends BaseController {
  bool showComments = false;

  final PostPageController postPageController;

  final void Function(bool showComments) show;
  final User user;

  PostCommentContainerController(
      {this.postPageController, this.show, this.user});
}

class PostCommentContainer extends BaseView {
  final PostCommentContainerController controller;

  PostCommentContainer({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    return Container(
      height: controller.showComments
          ? ServiceProvider.instance.screenService
              .getHeightByPercentage(context, 97.5)
          : ServiceProvider.instance.screenService
              .getHeightByPercentage(context, 10),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (controller.postPageController.thePost.commentList.length > 0)
              InkWell(
                onTap: () {
                  double height;
                  controller.showComments = !controller.showComments;
                  controller.show(controller.showComments);

                  controller.refresh();
                  if (controller.showComments) {
                    controller.postPageController.deviceHeight > 750
                        ? height = ServiceProvider.instance.screenService
                            .getHeightByPercentage(context, 85)
                        : height = ServiceProvider.instance.screenService
                            .getHeightByPercentage(context, 100);
                  } else {
                    height = 0;
                  }
                  scrollScreen(
                      height: height,
                      controller:
                          controller.postPageController.scrollController,
                      timeBeforeAction: 100);
                },
                child: Card(
                  color: ServiceProvider
                      .instance.instanceStyleService.appStyle.leBleu,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Container(
                    height: ServiceProvider.instance.screenService
                        .getHeightByPercentage(context, 5),
                    // width: ServiceProvider.instance.screenService
                    //     .getWidthByPercentage(context, 50),
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
                          style: ServiceProvider
                              .instance.instanceStyleService.appStyle.body1,
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
                children:
                    controller.postPageController.thePost.commentList.map((c) {
                  return PostComment(
                    controller: PostCommentController(
                        postPageController: controller.postPageController,
                        user: controller.user,
                        comment: c,
                        commentType: CommentType.topLevel),
                  );
                }).toList(),
              ),
              Container(
                height: ServiceProvider.instance.screenService
                    .getHeightByPercentage(context, 5),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
