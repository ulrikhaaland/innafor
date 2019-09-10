import 'package:flutter/material.dart';
import 'package:innafor/helper/helper.dart';
import 'package:innafor/model/comment.dart';
import 'package:innafor/model/user.dart';
import 'package:innafor/presentation/base_controller.dart';
import 'package:innafor/presentation/base_view.dart';
import 'package:innafor/service/service_provider.dart';
import '../post_page.dart';
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
    if (!mounted && controller.postPageController.thePost.commentList != null)
      return Container();

    return Container(
      height: controller.showComments
          ? ServiceProvider.instance.screenService
              .getHeightByPercentage(context, 77.5)
          : ServiceProvider.instance.screenService
              .getHeightByPercentage(context, 10),
      child: SingleChildScrollView(
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
                            ? "Skjul ${controller.postPageController.thePost.commentList.where((c) => c.isChildOfId == null).length} kommentarer"
                            : "Vis ${controller.postPageController.thePost.commentList.where((c) => c.isChildOfId == null).length} kommentarer",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.body1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // if (controller.showComments &&
            //     controller.postPageController.thePost.commentList.isNotEmpty)
            //   StreamBuilder(
            //     stream: Firestore.instance
            //         .collection(
            //             controller.postPageController.thePost.docRef.path +
            //                 "/comments")
            //         .snapshots(),
            //     //print an integer every 2secs, 10 times
            //     builder: (context, snapshot) {
            //       if (!snapshot.hasData) {
            //         return Text("Loading..");
            //       }

            //       return MediaQuery.removePadding(
            //         context: context,
            //         removeTop: true,
            //         child: ListView.builder(
            //           shrinkWrap: true,
            //           itemCount: snapshot.data.documents.length,
            //           itemBuilder: (context, index) {
            //             DocumentSnapshot docSnap =
            //                 snapshot.data.documents[index];
            //             if (docSnap.data["is_child_of_id"] == null) {
            //               Comment c = controller
            //                   .postPageController.thePost.commentList
            //                   .firstWhere((c) => c.id == docSnap.documentID);
            //               return PostComment(
            //                 controller: PostCommentController(
            //                     postPageController:
            //                         controller.postPageController,
            //                     user: controller.user,
            //                     comment: c,
            //                     commentType: CommentType.topLevel),
            //               );
            //             }
            //           },
            //         ),
            //       );
            //     },
            //   ),
            if (controller.showComments &&
                controller
                    .postPageController.thePost.commentList.isNotEmpty) ...[
              Column(
                children:
                    //  controller.commentWidgetList

                    controller.postPageController.thePost.commentList
                        .where((c) => c.isChildOfId == null)
                        .map((c) {
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
