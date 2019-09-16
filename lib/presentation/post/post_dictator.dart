import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innafor/helper/auth.dart';
import 'package:innafor/model/comment.dart';
import 'package:innafor/model/post.dart';
import 'package:innafor/model/user.dart';
import 'package:innafor/presentation/base_controller.dart';
import 'package:innafor/presentation/base_view.dart';
import 'package:innafor/presentation/post/post_page.dart';
import 'package:innafor/provider/comment_provider.dart';
import 'package:innafor/provider/post_provider.dart';

class PostDictatorController extends BaseController {
  final BaseAuth auth;

  final User user;

  List<String> postIds;

  List<PostPageController> postPageCtrlrs;

  PostDictatorController({this.auth, this.user});

  initState() {
    postIds = <String>[];

    postPageCtrlrs = <PostPageController>[];

    getCircle();

    super.initState();
  }

  Future getCircle() async {
    QuerySnapshot circleSnap =
        await Firestore.instance.collection("circle/1/post").getDocuments();
    circleSnap.documents.forEach((id) => postIds.add(id.documentID));
    checkCircle();
  }

  checkCircle() async {
    while (postPageCtrlrs.length < 5) {
      if (postIds.length >= postPageCtrlrs.length) {
        postPageCtrlrs.add(PostPageController(
            post: await PostProvider().providePost(postIds[0]),
            comments: await CommentProvider().provideComments(postIds[0])));
        postIds.removeAt(0);
      } else {
        refresh();
        return;
      }
    }
  }
}

class PostDictatorPage extends BaseView {
  final PostDictatorController controller;

  PostDictatorPage({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    if (controller.postPageCtrlrs.isEmpty) return Container();

    return PostPage(
      controller: controller.postPageCtrlrs[0],
    );
  }
}
