import 'package:innafor/base_controller.dart';
import 'package:innafor/base_view.dart';
import 'package:innafor/helper.dart';
import 'package:innafor/objects/comment.dart';
import 'package:innafor/objects/user.dart';
import 'package:innafor/post/post-comment/post_comment_page.dart';
import 'package:innafor/post/post_page.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innafor/widgets/popup/innafor_dialog.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

enum CommentType { comment, response, topLevel }

class PostCommentController extends BaseController {
  bool showComments = false;

  final Comment comment;

  bool favorite;

  final VoidCallback showBottomSheet;

  final User user;

  final CommentType commentType;

  TextStyle textStyle;

  PostPageController postPageController;

  double iconSize;

  PostCommentController(
      {this.comment, this.showBottomSheet, this.user, this.commentType});

  @override
  void initState() {
    setTypeDifferences();
    super.initState();
  }

  void setTypeDifferences() {
    switch (commentType) {
      case CommentType.topLevel:
        textStyle =
            ServiceProvider.instance.instanceStyleService.appStyle.body1Black;
        iconSize = ServiceProvider
            .instance.instanceStyleService.appStyle.iconSizeExtraSmall;

        break;

      case CommentType.response:
        textStyle =
            ServiceProvider.instance.instanceStyleService.appStyle.body1Black;
        iconSize = ServiceProvider
            .instance.instanceStyleService.appStyle.iconSizeExtraSmall;

        break;

      case CommentType.comment:
        textStyle = ServiceProvider
            .instance.instanceStyleService.appStyle.body1BlackBig;
        iconSize = ServiceProvider
            .instance.instanceStyleService.appStyle.iconSizeSmall;
        break;

      default:
        textStyle =
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

    if (controller.postPageController == null) {
      controller.postPageController = Provider.of<PostPageController>(context);
    }

    if (controller.favorite == null)
      controller.favorite =
          controller.comment.favoriteIds?.contains(controller.user.id);
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostCommentPage(
              controller: PostCommentPageController(
                  comment: controller.comment, user: controller.user),
            ),
          )),
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
                                top: getDefaultPadding(context)),
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
                    Container(
                      alignment: Alignment.topLeft,
                      width: ServiceProvider.instance.screenService
                          .getWidthByPercentage(context, 74),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: getDefaultPadding(context),
                                left: getDefaultPadding(context),
                                right: getDefaultPadding(context)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
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
                                InkWell(
                                  onTap: () => controller.showBottomSheet(),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        getTimeDifference(
                                            controller.comment.timestamp),
                                        style: ServiceProvider
                                            .instance
                                            .instanceStyleService
                                            .appStyle
                                            .timestamp,
                                      ),
                                      Container(
                                        width: getDefaultPadding(context),
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
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(getDefaultPadding(context)),
                            child: Text(
                              "@" +
                                      controller.postPageController.thePost
                                          .userNameId ??
                                  "",
                              style: controller.textStyle,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(getDefaultPadding(context)),
                            child: Text(
                              controller.comment.text ?? "",
                              style: controller.textStyle,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: getDefaultPadding(context),
                                right: getDefaultPadding(context)),
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => print("comments pressed"),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: getDefaultPadding(context)),
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

                                    controller.favorite = !controller.favorite;
                                    controller.refresh();
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: getDefaultPadding(context)),
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
                                        controller.comment.favoriteIds.length
                                                .toString() ??
                                            "0",
                                        style: ServiceProvider
                                            .instance
                                            .instanceStyleService
                                            .appStyle
                                            .timestamp,
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
              Divider(
                color: ServiceProvider
                    .instance.instanceStyleService.appStyle.textGrey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
