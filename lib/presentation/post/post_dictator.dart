import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innafor/helper/auth.dart';
import 'package:innafor/helper/helper.dart';
import 'package:innafor/model/circle.dart';
import 'package:innafor/model/user.dart';
import 'package:innafor/presentation/app-bar/innafor_app_bar.dart';
import 'package:innafor/presentation/base_controller.dart';
import 'package:innafor/presentation/base_view.dart';
import 'package:innafor/presentation/post/post_page.dart';
import 'package:innafor/provider/comment_provider.dart';
import 'package:innafor/provider/post_provider.dart';
import 'package:innafor/service/service_provider.dart';

class PostDictatorController extends BaseController {
  final BaseAuth auth;

  final User user;

  List<Circle> circles;

  PostPage thePostPage;

  PostDictatorController({this.auth, this.user});

  initState() {
    circles = <Circle>[];
    getCircle();

    super.initState();
  }

  Future getCircle() async {
    QuerySnapshot circlesSnap =
        await Firestore.instance.collection("circles").getDocuments();
    circlesSnap.documents.forEach((circleDoc) async {
      Circle circle = Circle.fromJson(circleDoc.data);

      circle.postPages = <PostPage>[];

      circle.postIds = <String>[];

      circle.docRef = circleDoc.reference;

      QuerySnapshot postSnaps =
          await circle.docRef.collection("posts").getDocuments();

      if (postSnaps.documents.isNotEmpty) {
        postSnaps.documents
            .forEach((postDoc) => circle.postIds.add(postDoc.documentID));

        circles.add(circle);

        checkCircle(circle: circle);
      }
    });
  }

  checkCircle({Circle circle}) async {
    while (circle.postPages.length < 5) {
      if (circle.postIds.length >= circle.postPages.length) {
        circle.postPages.add(
          PostPage(
            key: Key(circle.postIds[0]),
            controller: PostPageController(
              preview: true,
              post: await PostProvider().providePost(circle.postIds[0]),
              comments:
                  await CommentProvider().provideComments(circle.postIds[0]),
              onDone: () => setState(
                () {
                  circle.postPages.removeAt(0);
                },
              ),
            ),
          ),
        );

        circle.postIds.removeAt(0);
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

    if (controller.circles[0].postPages.isEmpty)
      return Container(
        color: Colors.white,
      );

    double padding = getDefaultPadding(context);

    // controller.auth.signOut();

    if (controller.thePostPage != null) return controller.thePostPage;

    return Scaffold(
      bottomNavigationBar: Container(
        width: ServiceProvider.instance.screenService
            .getWidthByPercentage(context, 10),
        height: ServiceProvider.instance.screenService
            .getHeightByPercentage(context, 10),
        child: Card(
          margin: EdgeInsets.all(padding * 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: padding * 10, right: padding * 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    iconSize: ServiceProvider
                        .instance.instanceStyleService.appStyle.iconSizeBig,
                    icon: Icon(
                      Icons.person_outline,
                      color: ServiceProvider.instance.instanceStyleService
                          .appStyle.inactiveIconColor,
                    ),
                    onPressed: () => controller.auth.signOut()),
                InkWell(
                  onTap: () => controller.auth.signOut(),
                  child: Text(
                    "?",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                IconButton(
                    iconSize: ServiceProvider.instance.instanceStyleService
                        .appStyle.iconSizeStandard,
                    icon: Icon(
                      Icons.add,
                      color: ServiceProvider.instance.instanceStyleService
                          .appStyle.inactiveIconColor,
                    ),
                    onPressed: () => controller.auth.signOut()),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(243, 246, 251, 1),
      // appBar: PreferredSize(
      //   preferredSize: Size(
      //       ServiceProvider.instance.screenService
      //           .getWidthByPercentage(context, 100),
      //       ServiceProvider.instance.screenService
      //           .getHeightByPercentage(context, 7.5)),
      //   child: InnaforAppBar(
      //     controller: InnaforAppBarController(auth: controller.auth),
      //   ),
      // ),
      body: ListView.builder(
          padding: EdgeInsets.only(
              top: ServiceProvider.instance.screenService
                  .getHeightByPercentage(context, 5)),
          itemCount: controller.circles.length,
          itemBuilder: (context, index) {
            Circle circle = controller.circles[index];
            return Padding(
              padding: EdgeInsets.only(
                  left: ServiceProvider.instance.screenService
                      .getWidthByPercentage(context, 5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(left: padding * 2, bottom: padding * 2),
                    child: Text(
                      circle.title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 35,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    height: ServiceProvider.instance.screenService
                        .getHeightByPercentage(context, 80),
                    width: ServiceProvider.instance.screenService
                        .getWidthByPercentage(context, 80),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        PostPage postPage = circle.postPages[0];
                        return Container(
                          width: ServiceProvider.instance.screenService
                              .getWidthByPercentage(context, 70),
                          child: GestureDetector(
                            onTap: () {
                              postPage.controller.preview = false;
                              controller.setState(() {
                                postPage.controller.disposable = false;
                                controller.thePostPage = postPage;
                              });
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => postPage));
                            },
                            child: Column(
                              children: <Widget>[postPage],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
    );

    // return PostPage(
    //   key: Key(controller.postPages[0].post.id),
    //   controller: controller.postPages[0],
    // );
  }
}
