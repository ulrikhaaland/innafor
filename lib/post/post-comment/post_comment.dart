import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:bss/helper.dart';
import 'package:bss/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class PostCommentController extends BaseController {
  bool showComments = false;
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
        child: IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Container(
                color: ServiceProvider
                    .instance.instanceStyleService.appStyle.imperial,
                alignment: Alignment.topLeft,
                width: ServiceProvider.instance.screenService
                    .getWidthByPercentage(context, 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // CircleAvatar(
                    //   backgroundColor: ServiceProvider
                    //       .instance.instanceStyleService.appStyle.mountbattenPink,
                    // )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                width: ServiceProvider.instance.screenService
                    .getWidthByPercentage(context, 65),
                color: ServiceProvider
                    .instance.instanceStyleService.appStyle.mountbattenPink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not i am not that.",
                      style: ServiceProvider
                          .instance.instanceStyleService.appStyle.body1,
                      // maxLines: 15,
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                width: ServiceProvider.instance.screenService
                    .getWidthByPercentage(context, 9),
                color: ServiceProvider
                    .instance.instanceStyleService.appStyle.leBleu,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
