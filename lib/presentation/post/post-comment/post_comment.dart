import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innafor/helper/helper.dart';
import 'package:innafor/model/comment.dart';
import 'package:innafor/model/report_dialog_info.dart';
import 'package:innafor/model/user.dart';
import 'package:innafor/presentation/base_controller.dart';
import 'package:innafor/presentation/base_view.dart';
import 'package:innafor/presentation/post/post-comment/post_comment_container.dart';
import 'package:innafor/presentation/post/post-comment/post_comment_page.dart';
import 'package:innafor/presentation/post/post_utilities.dart';
import 'package:innafor/presentation/widgets/buttons/fab.dart';
import 'package:innafor/presentation/widgets/circular_progress_indicator.dart';
import 'package:innafor/presentation/widgets/popup/main_dialog.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../post_page.dart';

class PostCommentController extends BaseController {
  bool showComments = false;

  final Comment comment;

  final CommentType commentType;

  final PostActionController actionController;

  bool favorite;

  User user;

  TextStyle bodyStyle;

  TextStyle iconTextStyle;

  final GlobalKey<ScaffoldState> scaffoldKey;

  final PostPageController postPageController;

  final PostCommentPageController postCommentPageController;

  final PostCommentContainerController containerController;

  final FabController fabController;

  final String answerToUserNameId;

  int childCount;

  var parentController;

  double iconSize;

  final String parentId;

  PostCommentController({
    this.comment,
    this.parentId,
    this.user,
    this.postPageController,
    this.actionController,
    this.answerToUserNameId,
    this.commentType,
    this.scaffoldKey,
    this.fabController,
    this.postCommentPageController,
    this.parentController,
    this.containerController,
  });

  @override
  void initState() {
    getChildCount();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scaffoldKey?.currentState?.dispose();
  }

  void getChildCount() {
    if (comment.id != null) {
      childCount = postPageController.comments.where((c) => checkId(c)).length;
      setState(() {});
    } else {
      Timer(Duration(milliseconds: 100), () => getChildCount());
    }
  }

  bool checkId(Comment c) {
    if (c.isChildOfId == comment.id && c != comment) {
      return true;
    } else {
      return false;
    }
  }

  void setTypeDifferences() {
    switch (commentType) {
      case CommentType.topLevel:
        bodyStyle =
            ServiceProvider.instance.instanceStyleService.appStyle.body1Black;
        iconSize = ServiceProvider
            .instance.instanceStyleService.appStyle.iconSizeExtraSmall;
        iconTextStyle =
            ServiceProvider.instance.instanceStyleService.appStyle.timestamp;

        break;

      case CommentType.response:
        bodyStyle =
            ServiceProvider.instance.instanceStyleService.appStyle.body1Black;
        iconSize = ServiceProvider
            .instance.instanceStyleService.appStyle.iconSizeExtraSmall;
        iconTextStyle =
            ServiceProvider.instance.instanceStyleService.appStyle.timestamp;

        break;

      case CommentType.comment:
        bodyStyle = ServiceProvider
            .instance.instanceStyleService.appStyle.body1BlackBig;
        iconSize = ServiceProvider
            .instance.instanceStyleService.appStyle.iconSizeSmall;
        iconTextStyle =
            ServiceProvider.instance.instanceStyleService.appStyle.body1Grey;

        break;

      default:
        bodyStyle =
            ServiceProvider.instance.instanceStyleService.appStyle.body1Black;
    }
  }
}

class PostComment extends BaseView {
  final Key key;
  final PostCommentController controller;

  PostComment({this.controller, this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    if (controller.childCount == null) {
      return CPI(false);
    }

    double padding = getDefaultPadding(context);

    controller.setTypeDifferences();

    controller.favorite =
        controller.comment.favoriteIds?.contains(controller.user.id);
    Widget commentWidget = GestureDetector(
      onTap: () async {
        if (controller.commentType != CommentType.comment) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostCommentPage(
                controller: PostCommentPageController(
                  actionController: controller.actionController,
                  comment: controller.comment,
                  user: controller.user,
                  postPageController: controller.postPageController,
                ),
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(top: padding * 2),
        child: Container(
          color: Colors.transparent,
          width: ServiceProvider.instance.screenService
              .getWidthByPercentage(context, 93),
          child: Column(
            children: <Widget>[
              IntrinsicHeight(
                child: Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      width: ServiceProvider.instance.screenService
                          .getWidthByPercentage(context, 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CircleAvatar(
                            radius: ServiceProvider.instance.screenService
                                .getWidthByPercentage(context, 7.5),
                            backgroundColor: ServiceProvider.instance
                                .instanceStyleService.appStyle.mimiPink,
                            backgroundImage:
                                controller.comment.userImageUrl != null
                                    ? AdvancedNetworkImage(
                                        controller.comment.userImageUrl)
                                    : null,
                            child: Icon(
                              FontAwesomeIcons.userSecret,
                              color: ServiceProvider.instance
                                  .instanceStyleService.appStyle.textGrey,
                              size: ServiceProvider
                                  .instance
                                  .instanceStyleService
                                  .appStyle
                                  .iconSizeStandard,
                            ),
                          ),

                          // GestureDetector(
                          //   onTap: () => showDialog(
                          //       context: context,
                          //       builder: (context) => InnaforDialog(
                          //             title: "Vurderingsevne",
                          //             items: <Widget>[
                          //               Padding(
                          //                 padding: EdgeInsets.only(
                          //                     left: padding *
                          //                         4,
                          //                     right:
                          //                         padding *
                          //                             4,
                          //                     bottom: 24),
                          //                 child: Text(
                          //                   "Ved hjelp av kunstlig intelligens og maskinlæring... ;) blir hver bruker vurdert ut i fra hvor god brukeren er til å ",
                          //                   style: ServiceProvider
                          //                       .instance
                          //                       .instanceStyleService
                          //                       .appStyle
                          //                       .body1Black,
                          //                 ),
                          //               ),
                          //               Column(
                          //                 children: <Widget>[
                          //                   GestureDetector(
                          //                     onTap: () =>
                          //                         Navigator.of(context).pop(),
                          //                     child: Container(
                          //                       height: ServiceProvider
                          //                           .instance.screenService
                          //                           .getHeightByPercentage(
                          //                               context, 7.5),
                          //                       width: ServiceProvider
                          //                           .instance.screenService
                          //                           .getWidthByPercentage(
                          //                               context, 100),
                          //                       decoration: BoxDecoration(
                          //                           color: ServiceProvider
                          //                               .instance
                          //                               .instanceStyleService
                          //                               .appStyle
                          //                               .leBleu,
                          //                           borderRadius:
                          //                               BorderRadius.only(
                          //                                   bottomLeft: Radius
                          //                                       .circular(8),
                          //                                   bottomRight:
                          //                                       Radius.circular(
                          //                                           8))),
                          //                       child: Center(
                          //                         child: Text(
                          //                           "Jeg forstår",
                          //                           style: ServiceProvider
                          //                               .instance
                          //                               .instanceStyleService
                          //                               .appStyle
                          //                               .titleWhite,
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ],
                          //           )),
                          //   child: CircularPercentIndicator(
                          //     radius: ServiceProvider.instance.screenService
                          //         .getWidthByPercentage(context, 15),
                          //     percent: 0.75,
                          //     progressColor: ServiceProvider
                          //         .instance
                          //         .instanceStyleService
                          //         .appStyle
                          //         .mountbattenPink,
                          //     center: Text(
                          //       "75%",
                          //       style: ServiceProvider.instance
                          //           .instanceStyleService.appStyle.body1Black,
                          //     ),
                          //   ),
                          // ),
                          // GestureDetector(
                          //   onTap: () => Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => PostCommentPage(
                          //               controller: PostCommentPageController(
                          //                 comment: controller.comment,
                          //               ),
                          //             )),
                          //   ),
                          //   child: Icon(
                          //     FontAwesomeIcons.reply,
                          //     size: ServiceProvider
                          //         .instance
                          //         .instanceStyleService
                          //         .appStyle
                          //         .iconSizeStandard,
                          //     color: ServiceProvider.instance
                          //         .instanceStyleService.appStyle.leBleu,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        width: ServiceProvider.instance.screenService
                            .getWidthByPercentage(context, 74),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (controller.commentType == CommentType.response)
                              InkWell(
                                onTap: () => print("GO TO OP PROFILE"),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: padding,
                                      left: padding,
                                      right: padding),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Svar til @",
                                        style: ServiceProvider
                                            .instance
                                            .instanceStyleService
                                            .appStyle
                                            .coloredText,
                                      ),
                                      Expanded(
                                        child: Text(
                                          controller.answerToUserNameId ??
                                              "N/A",
                                          style: ServiceProvider
                                              .instance
                                              .instanceStyleService
                                              .appStyle
                                              .coloredText,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            else
                              Container(),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: padding, left: padding, right: padding),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              controller.comment.userName ??
                                                  "Anonym",
                                              style: ServiceProvider
                                                  .instance
                                                  .instanceStyleService
                                                  .appStyle
                                                  .smallTitle,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      DialogContentType dialogType;
                                      if (controller.comment.uid !=
                                          controller.user.id) {
                                        dialogType = DialogContentType.report;
                                      } else {
                                        dialogType = DialogContentType.isOwner;
                                      }

                                      controller.parentController
                                          .bottomSheetController
                                          .showBottomSheet(
                                        content: MainDialog(
                                          controller: MainDialogController(
                                            onDeleteComment: () {
                                              controller.parentController
                                                  .deleteComment(
                                                      controller.comment,
                                                      type: controller
                                                          .commentType);
                                              controller.parentController
                                                  .setState(() {});
                                            },
                                            dialogContentType: dialogType,
                                            divide: true,
                                            reportDialogInfo: ReportDialogInfo(
                                              reportedByUser: controller.user,
                                              reportedUser: User(
                                                  id: controller.comment.uid,
                                                  userName: controller
                                                      .comment.userName),
                                              reportType: ReportType.comment,
                                              id: controller.comment.id,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            getTimeDifference(
                                                controller.comment.timestamp),
                                            style: controller.iconTextStyle,
                                          ),
                                          Container(
                                            width: ServiceProvider
                                                .instance.screenService
                                                .getWidthByPercentage(
                                                    context, 1),
                                          ),
                                          Icon(
                                            FontAwesomeIcons.ellipsisH,
                                            color: ServiceProvider
                                                .instance
                                                .instanceStyleService
                                                .appStyle
                                                .textGrey,
                                            size: controller.iconSize,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                " @" +
                                        controller.postPageController.post
                                            .userNameId ??
                                    "",
                                style: controller.iconTextStyle,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(padding),
                              child: Text(
                                controller.comment.text ?? "",
                                style: controller.bodyStyle,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: padding, right: padding),
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      if (controller.favorite) {
                                        controller.comment.favoriteIds
                                            .remove(controller.user.id);
                                        controller.comment.docRef.updateData({
                                          "favorite_ids":
                                              controller.comment.favoriteIds
                                        });
                                      } else {
                                        controller.comment.favoriteIds
                                            .add(controller.user.id);
                                        controller.comment.docRef.updateData({
                                          "favorite_ids":
                                              controller.comment.favoriteIds
                                        });
                                      }

                                      controller.favorite =
                                          !controller.favorite;
                                      controller.setState(() {});
                                    },
                                    child: Container(
                                      width: 50,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: padding),
                                            child: Icon(
                                              controller.favorite
                                                  ? FontAwesomeIcons.solidHeart
                                                  : FontAwesomeIcons.heart,
                                              color: controller.favorite
                                                  ? ServiceProvider
                                                      .instance
                                                      .instanceStyleService
                                                      .appStyle
                                                      .mountbattenPink
                                                  : ServiceProvider
                                                      .instance
                                                      .instanceStyleService
                                                      .appStyle
                                                      .textGrey,
                                              size: controller.iconSize,
                                            ),
                                          ),
                                          Text(
                                            controller
                                                    .comment.favoriteIds?.length
                                                    .toString() ??
                                                "0",
                                            style: controller.iconTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (controller.commentType !=
                                          CommentType.comment &&
                                      controller.childCount > 0) ...[
                                    InkWell(
                                      child: Container(
                                        width: 50,
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: getDefaultPadding(
                                                      context)),
                                              child: Icon(
                                                FontAwesomeIcons.comment,
                                                color: ServiceProvider
                                                    .instance
                                                    .instanceStyleService
                                                    .appStyle
                                                    .textGrey,
                                                size: controller.iconSize,
                                              ),
                                            ),
                                            Text(
                                              controller.childCount.toString(),
                                              style: ServiceProvider
                                                  .instance
                                                  .instanceStyleService
                                                  .appStyle
                                                  .timestamp,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: padding * 4,
                                    ),
                                  ],
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              controller.commentType == CommentType.comment
                  ? Padding(
                      padding: EdgeInsets.only(bottom: padding),
                    )
                  : Divider(
                      color: ServiceProvider
                          .instance.instanceStyleService.appStyle.textGrey,
                    )
            ],
          ),
        ),
      ),
    );

    if (controller.commentType == CommentType.comment) {
      return Card(
        margin: EdgeInsets.zero,
        elevation: 6,
        child: commentWidget,
      );
    }
    return commentWidget;
  }
}