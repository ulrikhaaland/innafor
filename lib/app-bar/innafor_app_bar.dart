import 'package:bss/auth.dart';
import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:bss/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helper.dart';

class InnaforAppBarController extends BaseController {
  final BaseAuth auth;

  InnaforAppBarController({this.auth});
}

class InnaforAppBar extends BaseView {
  final InnaforAppBarController controller;

  InnaforAppBar({this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: getDefaultPadding(context) * 4),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(
                    iconSize: ServiceProvider.instance.instanceStyleService
                        .appStyle.iconSizeStandard,
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
                    iconSize: ServiceProvider
                        .instance.instanceStyleService.appStyle.iconSizeBig,
                    icon: Icon(
                      FontAwesomeIcons.question,
                      color: ServiceProvider.instance.instanceStyleService
                          .appStyle.activeIconColor,
                    ),
                    onPressed: () => null),
                IconButton(
                    iconSize: ServiceProvider.instance.instanceStyleService
                        .appStyle.iconSizeStandard,
                    icon: Icon(
                      FontAwesomeIcons.plus,
                      color: ServiceProvider.instance.instanceStyleService
                          .appStyle.inactiveIconColor,
                    ),
                    onPressed: () => Navigator.of(context).pushNamed("/post")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
