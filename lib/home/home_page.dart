import 'dart:async';
import 'package:bss/objects/post.dart';
import 'package:bss/auth.dart';
import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:bss/widgets/circular_progress_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../service/service_provider.dart';
import '../helper.dart';

class HomePageController extends BaseController {
  final BaseAuth auth;

  GlobalKey imageSizeKey = GlobalKey();

  var url;

  List<Post> postList;

  Post thePost;

  bool loaded = false;

  double imgContainerWidth;

  HomePageController({this.auth});
  @override
  void initState() {
    super.initState();
    postList = <Post>[];

    getPost();
  }

  void getImageWidth() {
    final RenderBox renderBoxRed =
        imageSizeKey.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;
    print(sizeRed.width);
    imgContainerWidth = sizeRed.width;
  }

  void getPost() async {
    QuerySnapshot qSnap =
        await Firestore.instance.collection("post").getDocuments();

    qSnap.documents.forEach((d) => postList.add(Post(
        message: d.data["message"],
        imgUrlList: d.data["img"],
        commentCount: d.data["comments"],
        title: d.data["title"])));

    thePost = postList[0];

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
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.only(top: getDefaultPadding(context) * 8),
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
                            FontAwesomeIcons.solidUser,
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
                  padding: EdgeInsets.only(
                    left: getDefaultPadding(context) * 2,
                    right: getDefaultPadding(context) * 2,
                  ),
                  child: controller.thePost != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Container(
                            key: controller.imageSizeKey,
                            child: TransitionToImage(
                              image: AdvancedNetworkImage(
                                controller.thePost.imgUrlList[0],
                                loadedCallback: () {
                                  controller.loaded = true;
                                  Timer(Duration(milliseconds: 50), () {
                                    controller.getImageWidth();
                                    controller.refresh();
                                  });
                                },
                              ),
                            ),
                          ))
                      : Container(),
                ),
                Positioned(
                    width: controller.loaded
                        ? controller.imgContainerWidth
                        : 352.60851873884593,
                    bottom: ServiceProvider.instance.screenService
                        .getHeightByPercentage(context, 2.5),
                    child: Container(
                      padding: EdgeInsets.only(
                        left: ServiceProvider.instance.screenService
                            .getPortraitWidthByPercentage(context, 5),
                        right: ServiceProvider.instance.screenService
                            .getPortraitWidthByPercentage(context, 5),
                      ),
                      child: Container(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: ServiceProvider.instance.screenService
                                  .getWidthByPercentage(context, 80),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    controller.thePost.title,
                                    style: ServiceProvider.instance
                                        .instanceStyleService.appStyle.title,
                                  ),
                                  if (controller.thePost.message.length >
                                      120) ...[
                                    Text(
                                      controller.thePost.message
                                              .substring(0, 120) +
                                          "...",
                                      style: ServiceProvider.instance
                                          .instanceStyleService.appStyle.body1,
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.start,
                                    ),
                                    // GestureDetector(
                                    //   onTap: () => null,
                                    //   child: Text(
                                    //     "Se hele",
                                    //     style: ServiceProvider
                                    //         .instance
                                    //         .instanceStyleService
                                    //         .appStyle
                                    //         .buttonText,
                                    //   ),
                                    // ),
                                  ] else ...[
                                    Text(
                                      controller.thePost.message,
                                      style: ServiceProvider.instance
                                          .instanceStyleService.appStyle.body1,
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (controller.thePost.message.length > 120) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  IconButton(
                                    padding: EdgeInsets.only(
                                        left: 0,
                                        right: getDefaultPadding(context) * 2),
                                    icon: controller.thePost.commentCount > 0
                                        ? Icon(
                                            FontAwesomeIcons.plus,
                                          )
                                        : Container(),
                                    color: Colors.white,
                                    iconSize: ServiceProvider
                                        .instance
                                        .instanceStyleService
                                        .appStyle
                                        .iconSizeStandard,
                                    onPressed: () => null,
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.only(
                                      left: getDefaultPadding(context) * 2,
                                    ),
                                    icon: Icon(FontAwesomeIcons.solidUser),
                                    iconSize: ServiceProvider
                                        .instance
                                        .instanceStyleService
                                        .appStyle
                                        .iconSizeStandard,
                                    color: Colors.white,
                                    onPressed: () => null,
                                  ),
                                ],
                              ),
                            ],

                            // IconButton(
                            //   padding: EdgeInsets.only(
                            //       left: getDefaultPadding(context) * 2,
                            //       right: getDefaultPadding(context) * 2),
                            //   icon: Icon(
                            //     FontAwesomeIcons.solidEnvelope,
                            //   ),
                            //   color: ServiceProvider.instance
                            //       .instanceStyleService.appStyle.imperial,
                            //   iconSize: ServiceProvider.instance
                            //       .instanceStyleService.appStyle.iconSizeBig,
                            //   onPressed: () => null,
                            // ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                RatingBar(
                  itemPadding: EdgeInsets.only(left: 8, right: 8, top: 8),
                  onRatingUpdate: (r) => print(r),
                  allowHalfRating: true,
                  ratingWidget: RatingWidget(
                      empty: Icon(
                        FontAwesomeIcons.star,
                        color: ServiceProvider.instance.instanceStyleService
                            .appStyle.inactiveIconColor,
                      ),
                      full: Icon(
                        FontAwesomeIcons.solidStar,
                        color: ServiceProvider.instance.instanceStyleService
                            .appStyle.mountbattenPink,
                      ),
                      half: Icon(
                        FontAwesomeIcons.starHalfAlt,
                        color: ServiceProvider.instance.instanceStyleService
                            .appStyle.mountbattenPink,
                      )),
                ),
                // Text("data")
              ],
            ),
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
