import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:bss/helper.dart';
import 'package:bss/objects/comment.dart';
import 'package:bss/objects/post.dart';
import 'package:bss/post/post-comment/post_comment_page.dart';
import 'package:bss/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostCommentController extends BaseController {
  bool showComments = false;

  final Comment comment;

  PostCommentController({this.comment});
}

class PostComment extends BaseView {
  final PostCommentController controller;

  PostComment({this.controller});
  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();
    return Padding(
      padding: EdgeInsets.only(top: getDefaultPadding(context) * 2),
      child: Container(
        width: ServiceProvider.instance.screenService
            .getWidthByPercentage(context, 93),
        child: GestureDetector(
          onTap: () => print("Container tapped"),
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
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PostCommentPage(
                                        controller: PostCommentPageController(
                                          comment: controller.comment,
                                        ),
                                      )),
                            ),
                            child: Icon(
                              FontAwesomeIcons.reply,
                              size: ServiceProvider
                                  .instance
                                  .instanceStyleService
                                  .appStyle
                                  .iconSizeStandard,
                              color: ServiceProvider.instance
                                  .instanceStyleService.appStyle.leBleu,
                            ),
                          ),
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
                                Row(
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
                                    GestureDetector(
                                      onTap: () => print("Open DIALOG"),
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        color: ServiceProvider
                                            .instance
                                            .instanceStyleService
                                            .appStyle
                                            .textGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(getDefaultPadding(context)),
                            child: Text(
                              controller.comment.text ?? "",
                              style: ServiceProvider.instance
                                  .instanceStyleService.appStyle.body1Black,
                              // maxLines: 15,
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
                                          size: ServiceProvider
                                              .instance
                                              .instanceStyleService
                                              .appStyle
                                              .iconSizeExtraSmall,
                                        ),
                                      ),
                                      Text(
                                        controller.comment.children.length
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
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: getDefaultPadding(context)),
                                      child: Icon(
                                        FontAwesomeIcons.heart,
                                        color: ServiceProvider
                                            .instance
                                            .instanceStyleService
                                            .appStyle
                                            .textGrey,
                                        size: ServiceProvider
                                            .instance
                                            .instanceStyleService
                                            .appStyle
                                            .iconSizeExtraSmall,
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
                                    )
                                  ],
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
