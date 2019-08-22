import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:innafor/base_controller.dart';
import 'package:innafor/base_view.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:innafor/widgets/textfield/primary_textfield.dart';

import '../../helper.dart';

class PostNewCommentController extends BaseController {
  final Widget userImage;

  final VoidCallback onDisposed;

  PostNewCommentController({this.userImage, this.onDisposed});

  @override
  void dispose() {
    super.dispose();
    print("Disposed");
    onDisposed();
  }
}

class PostNewComment extends BaseView {
  final PostNewCommentController controller;

  PostNewComment({this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Container(
              width: ServiceProvider.instance.screenService
                  .getWidthByPercentage(context, 18),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: getDefaultPadding(context)),
                      child: controller.userImage),
                ],
              ),
            ),
            Container(
              width: ServiceProvider.instance.screenService
                  .getWidthByPercentage(context, 75),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    autocorrect: true,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 10,
                    maxLength: 280,

                    textInputAction: TextInputAction.done,
                    cursorRadius: Radius.circular(1),
                    // keyboardType: TextInputType.phone,
                    cursorColor: ServiceProvider
                        .instance.instanceStyleService.appStyle.imperial,
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.body1Black,
                    onSaved: (val) => null,
                    onFieldSubmitted: (val) => null,
                    decoration: InputDecoration(
                      hintText: "Hva skjer?",
                      hintStyle: ServiceProvider
                          .instance.instanceStyleService.appStyle.body1Grey,
                      counterStyle: TextStyle(
                          color: ServiceProvider
                              .instance.instanceStyleService.appStyle.imperial),
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
    );
    // return Scaffold(
    //   backgroundColor: ServiceProvider
    //       .instance.instanceStyleService.appStyle.backgroundColor,
    //   appBar: AppBar(
    //     iconTheme: IconThemeData(
    //         color: ServiceProvider
    //             .instance.instanceStyleService.appStyle.imperial),
    //     automaticallyImplyLeading: true,
    //     backgroundColor: ServiceProvider
    //         .instance.instanceStyleService.appStyle.backgroundColor,
    //     elevation: 0,
    //     title: Text(
    //       "Ny kommentar",
    //       style: ServiceProvider
    //           .instance.instanceStyleService.appStyle.secondaryTitle,
    //     ),
    //     actions: <Widget>[
    //       Center(
    //         child: Padding(
    //           padding: EdgeInsets.only(right: 16.0),
    //           child: InkWell(
    //             child: Text(
    //               "Lagre",
    //               style: ServiceProvider
    //                   .instance.instanceStyleService.appStyle.coloredText,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    //   body: Container(
    //     decoration: BoxDecoration(
    //       border: Border(
    //         bottom: BorderSide(
    //           color: ServiceProvider
    //               .instance.instanceStyleService.appStyle.mountbattenPink,
    //         ),
    //       ),
    //     ),
    //     child: IntrinsicHeight(
    //       child: Row(
    //         children: <Widget>[
    //           Container(
    //             width: ServiceProvider.instance.screenService
    //                 .getWidthByPercentage(context, 18),
    //             child: Column(
    //               children: <Widget>[
    //                 Padding(
    //                     padding:
    //                         EdgeInsets.only(top: getDefaultPadding(context)),
    //                     child: controller.userImage),
    //               ],
    //             ),
    //           ),
    //           Container(
    //             width: ServiceProvider.instance.screenService
    //                 .getWidthByPercentage(context, 82),
    //             child: Column(
    //               children: <Widget>[
    //                 TextFormField(
    //                   autocorrect: true,
    //                   autofocus: true,
    //                   textCapitalization: TextCapitalization.sentences,
    //                   maxLines: 10,
    //                   maxLength: 280,

    //                   textInputAction: TextInputAction.done,
    //                   cursorRadius: Radius.circular(1),
    //                   // keyboardType: TextInputType.phone,
    //                   cursorColor: ServiceProvider
    //                       .instance.instanceStyleService.appStyle.imperial,
    //                   style: ServiceProvider
    //                       .instance.instanceStyleService.appStyle.body1Black,
    //                   onSaved: (val) => null,
    //                   onFieldSubmitted: (val) => null,
    //                   decoration: InputDecoration(
    //                     hintText: "Hva skjer?",
    //                     hintStyle: ServiceProvider
    //                         .instance.instanceStyleService.appStyle.body1Grey,
    //                     counterStyle: TextStyle(
    //                         color: ServiceProvider.instance.instanceStyleService
    //                             .appStyle.imperial),
    //                     enabledBorder: UnderlineInputBorder(
    //                       borderSide: BorderSide.none,
    //                     ),
    //                     focusedBorder: UnderlineInputBorder(
    //                       borderSide: BorderSide.none,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
