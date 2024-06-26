import 'package:innafor/base_controller.dart';
import 'package:innafor/base_view.dart';
import 'package:innafor/helper.dart';
import 'package:innafor/objects/comment.dart';
import 'package:innafor/objects/report_dialog_info.dart';
import 'package:innafor/objects/user.dart';
import 'package:innafor/post/post-comment/post_comment_page.dart';
import 'package:innafor/post/post_page.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innafor/widgets/buttons/fab.dart';
import 'package:innafor/widgets/popup/bottom_sheet.dart';
import 'package:innafor/widgets/popup/innafor_dialog.dart';
import 'package:innafor/widgets/popup/main_dialog.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class PostCommentController extends BaseController {
  bool showComments = false;

  final Comment comment;

  final CommentType commentType;

  bool favorite;

  final User user;

  TextStyle bodyStyle;

  TextStyle iconTextStyle;

  final GlobalKey<ScaffoldState> scaffoldKey;

  final PostPageController postPageController;

  final FabController fabController;

  final String answerToUserNameId;

  double iconSize;

  PostCommentController(
      {this.comment,
      this.user,
      this.postPageController,
      this.answerToUserNameId,
      this.commentType,
      this.scaffoldKey,
      this.fabController});

  @override
  void initState() {
    super.initState();
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
  final PostCommentController controller;

  PostComment({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

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
        padding: EdgeInsets.only(top: getDefaultPadding(context) * 2),
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
                          Padding(
                            padding: EdgeInsets.only(
                              top: getDefaultPadding(context),
                            ),
                            child: CircleAvatar(
                              radius: ServiceProvider.instance.screenService
                                  .getWidthByPercentage(context, 7.5),
                              backgroundColor: ServiceProvider
                                  .instance
                                  .instanceStyleService
                                  .appStyle
                                  .mountbattenPink,
                              backgroundImage: AdvancedNetworkImage(
                                  controller.comment.userImageUrl),
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
                          //                     left: getDefaultPadding(context) *
                          //                         4,
                          //                     right:
                          //                         getDefaultPadding(context) *
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
                                      top: getDefaultPadding(context),
                                      left: getDefaultPadding(context),
                                      right: getDefaultPadding(context)),
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
                                  top: getDefaultPadding(context),
                                  left: getDefaultPadding(context),
                                  right: getDefaultPadding(context)),
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
                                              controller.comment.userName,
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
                                      controller.postPageController
                                          .bottomSheetController
                                          .showBottomSheet(
                                        content: MainDialog(
                                          controller: MainDialogController(
                                            dialogContentType:
                                                DialogContentType.report,
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
                              // width: ServiceProvider
                              //     .instance.screenService
                              //     .getWidthByPercentage(context, 15),
                              child: Text(
                                " @" +
                                        controller.postPageController.thePost
                                            .userNameId ??
                                    "",
                                style: controller.iconTextStyle,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            controller.commentType == CommentType.comment
                                ? Container(
                                    height: ServiceProvider
                                        .instance.screenService
                                        .getWidthByPercentage(context, 0),
                                  )
                                : Container(),
                            Padding(
                              padding:
                                  EdgeInsets.all(getDefaultPadding(context)),
                              child: Text(
                                controller.comment.text ?? "",
                                style: controller.bodyStyle,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: getDefaultPadding(context),
                                  right: getDefaultPadding(context)),
                              child: Row(
                                children: <Widget>[
                                  if (controller.commentType !=
                                      CommentType.comment) ...[
                                    InkWell(
                                      onTap: () => print("comments pressed"),
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right:
                                                    getDefaultPadding(context)),
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
                                            controller.comment.children?.length
                                                .toString(),
                                            style: ServiceProvider
                                                .instance
                                                .instanceStyleService
                                                .appStyle
                                                .timestamp,
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: getDefaultPadding(context) * 4,
                                    ),
                                  ],
                                  GestureDetector(
                                    onTap: () {
                                      if (controller.favorite) {
                                        controller.comment.favoriteIds
                                            .remove(controller.user.id);
                                        controller.comment.docRef
                                            .collection("favorites")
                                            .document(controller.user.id)
                                            .delete();
                                      } else {
                                        controller.comment.favoriteIds
                                            .add(controller.user.id);
                                        controller.comment.docRef
                                            .collection("favorites")
                                            .document(controller.user.id)
                                            .setData({});
                                      }

                                      controller.favorite =
                                          !controller.favorite;
                                      controller.refresh();
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right:
                                                  getDefaultPadding(context)),
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
                                          controller.comment.favoriteIds?.length
                                                  .toString() ??
                                              "0",
                                          style: controller.iconTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   alignment: Alignment.topCenter,
                    //   width: ServiceProvider.instance.screenService
                    //       .getWidthByPercentage(context, 9),
                    //   child: Padding(
                    //     padding: EdgeInsets.only(top: getDefaultPadding(context)),
                    //     child: GestureDetector(
                    //       onTap: () => print("Open DIALOG"),
                    //       child: Icon(
                    //         Icons.arrow_drop_down,
                    //         color: ServiceProvider
                    //             .instance.instanceStyleService.appStyle.textGrey,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
              controller.commentType == CommentType.comment
                  ? Padding(
                      padding:
                          EdgeInsets.only(bottom: getDefaultPadding(context)),
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
        elevation: 3,
        child: commentWidget,
      );
    }
    return commentWidget;
  }
}
