import 'package:flutter/material.dart';
import 'package:innafor/helper/helper.dart';
import 'package:innafor/model/comment.dart';
import 'package:innafor/model/user.dart';
import 'package:innafor/presentation/base_controller.dart';
import 'package:innafor/presentation/base_view.dart';
import 'package:innafor/presentation/post/post_utilities.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:provider/provider.dart';
import '../post_page.dart';
import 'post_comment.dart';

class PostCommentContainerController extends BaseController {
  bool showComments = false;

  final PostPageController postPageController;

  final void Function(bool showComments) show;
  User user;

  final PostActionController actionController;

  PostCommentContainerController({
    this.postPageController,
    this.actionController,
    this.show,
    this.user,
  });

  @override
  void initState() {
    super.initState();
  }
}

class PostCommentContainer extends BaseView {
  final PostCommentContainerController controller;

  PostCommentContainer({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted && controller.postPageController.comments != null)
      return Container();

    controller.user = Provider.of<User>(context);
    return Container(
      // height: controller.showComments
      //     ? ServiceProvider.instance.screenService
      //         .getHeightByPercentage(context, 50.5)
      //     : ServiceProvider.instance.screenService
      //         .getHeightByPercentage(context, 10),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              double height;
              controller.showComments = !controller.showComments;
              controller.show(controller.showComments);
              controller.setState(() {});
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
                  controller: controller.postPageController.scrollController,
                  timeBeforeAction: 100);
            },
            child: Card(
              color:
                  ServiceProvider.instance.instanceStyleService.appStyle.leBleu,
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
                          ? "Skjul ${controller.postPageController.comments.where((c) => c.isChildOfId == null).length} kommentarer"
                          : "Vis ${controller.postPageController.comments.where((c) => c.isChildOfId == null).length} kommentarer",
                      style: ServiceProvider
                          .instance.instanceStyleService.appStyle.body1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (controller.showComments &&
              controller.postPageController.comments.isNotEmpty) ...[
            Container(
              height: controller.showComments
                  ? ServiceProvider.instance.screenService
                      .getHeightByPercentage(context, 75)
                  : ServiceProvider.instance.screenService
                      .getHeightByPercentage(context, 5),
              width: ServiceProvider.instance.screenService
                  .getWidthByPercentage(context, 90),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                // shrinkWrap: true,
                itemCount: controller.postPageController.comments.length,
                itemBuilder: (context, index) {
                  if (controller
                          .postPageController.comments[index].isChildOfId ==
                      null)
                    return PostComment(
                      key:
                          Key(controller.postPageController.comments[index].id),
                      controller: PostCommentController(
                          actionController: controller.actionController,
                          postPageController: controller.postPageController,
                          parentController: controller.postPageController,
                          containerController: this.controller,
                          user: controller.user,
                          comment:
                              controller.postPageController.comments[index],
                          commentType: CommentType.topLevel),
                    );
                },
              ),
            ),
          ] else if (controller.showComments) ...[
            Container(
              height: controller.showComments
                  ? ServiceProvider.instance.screenService
                      .getHeightByPercentage(context, 75)
                  : ServiceProvider.instance.screenService
                      .getHeightByPercentage(context, 5),
            ),
          ]
        ],
      ),
    );
  }
}
