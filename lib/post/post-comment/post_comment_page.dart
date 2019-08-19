import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:bss/objects/comment.dart';
import 'package:bss/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class PostCommentPageController extends BaseController {
  final Comment comment;

  PostCommentPageController({this.comment});
}

class PostCommentPage extends BaseView {
  final PostCommentPageController controller;

  PostCommentPage({this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ServiceProvider
          .instance.instanceStyleService.appStyle.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ServiceProvider
            .instance.instanceStyleService.appStyle.backgroundColor,
        title: Text(
          "Kommentar",
          style: ServiceProvider
              .instance.instanceStyleService.appStyle.secondaryTitle,
        ),
        // bottom: PreferredSize(
        //   preferredSize: Size(0, 0),
        //   child: Divider(
        //     color:
        //         ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
        //   ),
        // ),
      ),
    );
  }
}
