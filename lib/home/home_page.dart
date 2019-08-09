import 'dart:math';
import 'package:bss/objects/post.dart';
import 'package:bss/widgets/cc_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:bss/auth.dart';
import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../service/service_provider.dart';
import '../helper.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

class HomePageController extends BaseController {
  final BaseAuth auth;

  var url;

  List<Post> postList;

  Post thePost;

  HomePageController({this.auth});
  @override
  void initState() {
    super.initState();
    postList = <Post>[];
    getPost();
  }

  void getPost() async {
    QuerySnapshot qSnap =
        await Firestore.instance.collection("post").getDocuments();

    qSnap.documents.forEach((d) => postList.add(Post(
        message: d.data["message"],
        imgUrlList: d.data["img"],
        commentCount: d.data["comments"])));

    thePost = postList[0];

//     final ref = FirebaseStorage.instance.ref().child('123.png');
// // no need of the file extension, the name will do fine.
//     url = await ref.getDownloadURL();
    refresh();
  }
}

class HomePage extends BaseView {
  final HomePageController controller;

  final String category = "Ingen valgt";

  HomePage({
    this.controller,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: getDefaultPadding(context) * 6),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                          iconSize: ServiceProvider.instance
                              .instanceStyleService.appStyle.iconSizeStandard,
                          icon: Icon(
                            FontAwesomeIcons.user,
                            color: ServiceProvider.instance.instanceStyleService
                                .appStyle.inactiveIconColor,
                          ),
                          onPressed: () => controller.auth.signOut()),
                      // Expanded(
                      //   child: Container(
                      //     height: ServiceProvider.instance.screenService
                      //         .getHeightByPercentage(context, 5),
                      //     width: ServiceProvider.instance.screenService
                      //         .getWidthByPercentage(context, 70),
                      //     decoration: BoxDecoration(
                      //         border: Border.all(
                      //             color: ServiceProvider
                      //                 .instance
                      //                 .instanceStyleService
                      //                 .appStyle
                      //                 .mountbattenPink),
                      //         borderRadius:
                      //             BorderRadius.all(Radius.circular(8))),
                      //     child: Align(
                      //         alignment: Alignment.centerLeft,
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Row(
                      //             children: <Widget>[
                      //               Text(
                      //                 "Kategori: $category",
                      //                 style: TextStyle(
                      //                     fontFamily: "Montserrat",
                      //                     color: Colors.black),
                      //                 textAlign: TextAlign.start,
                      //                 overflow: TextOverflow.ellipsis,
                      //               ),
                      //             ],
                      //           ),
                      //         )),
                      //   ),
                      // ),
                      IconButton(
                          iconSize: ServiceProvider.instance
                              .instanceStyleService.appStyle.iconSizeBig,
                          icon: Icon(
                            FontAwesomeIcons.question,
                            color: ServiceProvider.instance.instanceStyleService
                                .appStyle.activeIconColor,
                          ),
                          onPressed: () => controller.getPost()),
                      IconButton(
                          iconSize: ServiceProvider.instance
                              .instanceStyleService.appStyle.iconSizeStandard,
                          icon: Icon(
                            FontAwesomeIcons.plus,
                            color: ServiceProvider.instance.instanceStyleService
                                .appStyle.inactiveIconColor,
                          ),
                          onPressed: () =>
                              Navigator.of(context).pushNamed("/post")),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Stack(
              children: <Widget>[
                Container(
                  // alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(
                    left: getDefaultPadding(context) * 2,
                    right: getDefaultPadding(context) * 2,
                  ),

                  // height: ServiceProvider.instance.screenService
                  //     .getHeightByPercentage(context, 72.5),
                  child: controller.thePost != null
                      ?
                      // FittedBox(
                      //     // fit: BoxFit.fitWidth,
                      //     child:
                      ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child:
                              Image.network(controller.thePost.imgUrlList[0]))
                      // )
                      : Container(),
                ),
                Positioned(
                    bottom: ServiceProvider.instance.screenService
                        .getHeightByPercentage(context, 2.5),
                    right: ServiceProvider.instance.screenService
                        .getWidthByPercentage(context, 10),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.only(
                              left: getDefaultPadding(context) * 2,
                              right: getDefaultPadding(context) * 2),
                          icon: Icon(FontAwesomeIcons.infoCircle),
                          iconSize: ServiceProvider.instance
                              .instanceStyleService.appStyle.iconSizeBig,
                          color: Colors.white,
                          onPressed: () => null,
                        ),
                      ],
                    )),
                Positioned(
                    bottom: ServiceProvider.instance.screenService
                        .getHeightByPercentage(context, 2.5),
                    left: ServiceProvider.instance.screenService
                        .getWidthByPercentage(context, 10),
                    child: Row(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            IconButton(
                              padding: EdgeInsets.only(
                                  left: getDefaultPadding(context) * 2,
                                  right: getDefaultPadding(context) * 2),
                              icon: controller.thePost.commentCount > 0
                                  ? Icon(
                                      FontAwesomeIcons.comments,
                                      color: ServiceProvider.instance
                                          .instanceStyleService.appStyle.leBleu,
                                    )
                                  : Icon(
                                      FontAwesomeIcons.comments,
                                    ),
                              color: Colors.white,
                              iconSize: ServiceProvider.instance
                                  .instanceStyleService.appStyle.iconSizeBig,
                              onPressed: () => null,
                            ),
                          ],
                        ),
                        IconButton(
                          padding: EdgeInsets.only(
                              left: getDefaultPadding(context) * 2,
                              right: getDefaultPadding(context) * 2),
                          icon: Icon(
                            FontAwesomeIcons.envelope,
                          ),
                          color: ServiceProvider.instance.instanceStyleService
                              .appStyle.backgroundColor,
                          iconSize: ServiceProvider.instance
                              .instanceStyleService.appStyle.iconSizeBig,
                          onPressed: () => null,
                        ),
                      ],
                    )),
              ],
            ),
          ),
          RatingBar(
            itemPadding: EdgeInsets.only(left: 8, right: 8, top: 8),
            onRatingUpdate: (r) => print(r),
            allowHalfRating: true,
            ratingWidget: RatingWidget(
                empty: Icon(
                  FontAwesomeIcons.star,
                  color: ServiceProvider
                      .instance.instanceStyleService.appStyle.inactiveIconColor,
                ),
                full: Icon(
                  FontAwesomeIcons.solidStar,
                  color: ServiceProvider
                      .instance.instanceStyleService.appStyle.mountbattenPink,
                ),
                half: Icon(
                  FontAwesomeIcons.starHalfAlt,
                  color: ServiceProvider
                      .instance.instanceStyleService.appStyle.mountbattenPink,
                )),
          ),
          Container(
            height: ServiceProvider.instance.screenService
                .getHeightByPercentage(context, 2.5),
          )
        ],
      ),
    );
  }
}
