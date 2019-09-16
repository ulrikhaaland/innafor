import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innafor/helper/helper.dart';
import 'package:innafor/model/comment.dart';
import 'package:innafor/model/post.dart';
import 'package:innafor/model/user.dart';
import 'package:innafor/presentation/base_controller.dart';
import 'package:innafor/presentation/base_view.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:provider/provider.dart';

enum NewCommentType { comment, post }

class PostNewCommentController extends BaseController {
  User user;

  bool autoFocus = false;

  bool canPublish = false;

  final Post post;

  final Comment comment;

  final NewCommentType newCommentType;

  dynamic parentController;

  final FocusNode textFieldFocusNode = FocusNode();

  final TextEditingController textEditingController = TextEditingController();

  PostNewCommentController(
      {this.user,
      this.post,
      this.newCommentType,
      this.comment,
      this.parentController});

  @override
  void initState() {
    waitForAutoFocus();
    textEditingController.addListener(() {
      if (textEditingController.text.length > 0 && !canPublish) {
        canPublish = true;
        setState(() {});
      } else if (textEditingController.text.length == 0 && canPublish) {
        canPublish = false;
        setState(() {});
      }
    });
    super.initState();
  }

  void waitForAutoFocus() {
    // Timer(Duration(milliseconds: 100), () {
    //   textFieldFocusNode.requestFocus();
    // });
  }
}

class PostNewComment extends BaseView {
  final PostNewCommentController controller;

  PostNewComment({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    return Container(
      width: ServiceProvider.instance.screenService
          .getWidthByPercentage(context, 100),
      child: IntrinsicHeight(
        child: Container(
          padding: EdgeInsets.only(bottom: 12, top: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: ServiceProvider.instance.screenService
                    .getWidthByPercentage(context, 18),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: ServiceProvider.instance.screenService
                          .getHeightByPercentage(context, 5),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          FontAwesomeIcons.solidTimesCircle,
                          color: ServiceProvider
                              .instance.instanceStyleService.appStyle.imperial,
                          size: ServiceProvider.instance.instanceStyleService
                              .appStyle.iconSizeStandard,
                        ),
                      ),
                    ),
                    Divider(
                      color: ServiceProvider
                          .instance.instanceStyleService.appStyle.textGrey,
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(top: getDefaultPadding(context)),
                        child: controller.user.profileImageWidget),
                  ],
                ),
              ),
              Container(
                width: ServiceProvider.instance.screenService
                    .getWidthByPercentage(context, 75),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        // width: ServiceProvider.instance.screenService
                        //     .getWidthByPercentage(context, 18),
                        alignment: Alignment.centerRight,
                        height: ServiceProvider.instance.screenService
                            .getHeightByPercentage(context, 5),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                              onPressed: () {
                                if (controller.canPublish) {
                                  Comment comment = Comment(
                                    text: controller.textEditingController.text,
                                    timestamp: DateTime.now(),
                                    uid: controller.user.id,
                                    userImageUrl: controller.user.imageUrl,
                                    userName: controller.user.userName ?? "N/A",
                                    userRating: controller.user.rating,
                                    userNameId: controller.user.userNameId,
                                    favoriteIds: [],
                                  );
                                  if (controller.newCommentType !=
                                      NewCommentType.post) {
                                    comment.isChildOfId = controller.comment.id;
                                  }
                                  controller.parentController
                                      .saveComment(comment);

                                  controller.parentController.setState(() {});
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                "Publiser",
                                style: controller.canPublish
                                    ? ServiceProvider
                                        .instance
                                        .instanceStyleService
                                        .appStyle
                                        .coloredText
                                    : ServiceProvider
                                        .instance
                                        .instanceStyleService
                                        .appStyle
                                        .disabledColoredText,
                              ),
                            )),
                      ),
                    ),
                    Divider(
                      color: ServiceProvider
                          .instance.instanceStyleService.appStyle.textGrey,
                    ),
                    TextFormField(
                      controller: controller.textEditingController,
                      // focusNode: controller.textFieldFocusNode,
                      autofocus: true,
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 10,
                      maxLength: 280,
                      textInputAction: TextInputAction.done,
                      cursorRadius: Radius.circular(1),
                      cursorColor: ServiceProvider
                          .instance.instanceStyleService.appStyle.imperial,
                      style: ServiceProvider
                          .instance.instanceStyleService.appStyle.body1Black,
                      onSaved: (val) => null,
                      onFieldSubmitted: (val) => null,
                      decoration: InputDecoration(
                        hintText: "Tenkes?",
                        hintStyle: ServiceProvider
                            .instance.instanceStyleService.appStyle.body1Grey,
                        counterStyle: TextStyle(
                            color: ServiceProvider.instance.instanceStyleService
                                .appStyle.imperial),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}