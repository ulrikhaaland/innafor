import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:bss/objects/post.dart';
import 'package:bss/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helper.dart';

class PostContainerController extends BaseController {
  Post thePost;

  double imageWidth;

  double imageHeight;

  bool expanded = false;

  PostContainerController({
    this.thePost,
    this.imageWidth,
    this.imageHeight,
  });

  @override
  void initState() {
    super.initState();
  }
}

class PostContainer extends BaseView {
  final PostContainerController controller;

  PostContainer({this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: controller.imageWidth ?? 38.60851873884593,
      bottom: ServiceProvider.instance.screenService
          .getHeightByPercentage(context, 1.5),
      child: Container(
        // Not perfectly centered, fix!!
        padding: EdgeInsets.only(
          left: ServiceProvider.instance.screenService
              .getPortraitWidthByPercentage(context, 4.5),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: controller.expanded
                ? Color.fromRGBO(0, 0, 0, 0.5)
                : Color.fromRGBO(0, 0, 0, 0.1),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Padding(
            padding: EdgeInsets.all(getDefaultPadding(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          controller.thePost.title,
                          style: ServiceProvider
                              .instance.instanceStyleService.appStyle.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    controller.thePost.message.length > 120
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              padding: EdgeInsets.only(
                                  left: getDefaultPadding(context) * 2),
                              icon: controller.thePost.commentCount > 0
                                  ? Icon(
                                      controller.expanded
                                          ? FontAwesomeIcons.minus
                                          : FontAwesomeIcons.plus,
                                    )
                                  : Container(),
                              color: Colors.white,
                              iconSize: ServiceProvider.instance
                                  .instanceStyleService.appStyle.iconSizeSmall,
                              onPressed: () {
                                controller.expanded = !controller.expanded;
                                controller.refresh();
                              },
                            ),
                          )
                        : Container(),
                  ],
                ),
                Stack(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (controller.thePost.message.length > 120 &&
                                  !controller.expanded) ...[
                                Text(
                                  controller.thePost.message.substring(0, 120) +
                                      "...",
                                  style: ServiceProvider.instance
                                      .instanceStyleService.appStyle.body1,
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.start,
                                ),
                              ] else if (controller.expanded) ...[
                                Container(
                                  height: ServiceProvider.instance.screenService
                                      .getHeightByPercentage(context, 35),
                                  child: MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    removeBottom: true,
                                    child: Scrollbar(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: 1,
                                        itemBuilder: (context, index) => Text(
                                          controller.thePost.message,
                                          style: ServiceProvider
                                              .instance
                                              .instanceStyleService
                                              .appStyle
                                              .body1,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(),
                        IconButton(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.only(
                            left: getDefaultPadding(context) * 2,
                          ),
                          icon: Icon(FontAwesomeIcons.solidUser),
                          iconSize: ServiceProvider.instance
                              .instanceStyleService.appStyle.iconSizeSmall,
                          color: Colors.transparent,
                          onPressed: () => null,
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(
                          left: getDefaultPadding(context) * 2,
                        ),
                        icon: Icon(FontAwesomeIcons.solidUser),
                        iconSize: ServiceProvider.instance.instanceStyleService
                            .appStyle.iconSizeSmall,
                        color: Colors.white,
                        onPressed: () => null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
