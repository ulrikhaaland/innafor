import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innafor/base_controller.dart';
import 'package:innafor/base_view.dart';
import 'package:innafor/helper.dart';
import 'package:innafor/objects/comment.dart';
import 'package:innafor/objects/user.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:innafor/widgets/buttons/primary_button.dart';
import 'package:provider/provider.dart';

class ReportDialogController extends BaseController {
  final User userInView;

  User user;

  bool userInViewblocked;

  final VoidCallback onDone;

  final Comment comment;

  ReportDialogController({this.userInView, this.comment, this.onDone});
}

class ReportDialog extends BaseView {
  final ReportDialogController controller;

  ReportDialog({this.controller});
  @override
  Widget build(BuildContext context) {
    if (controller.user == null) {
      controller.user = Provider.of<User>(context);
      controller.userInView.blocked =
          controller.user.blockedUserId.contains(controller.userInView.id);
    }

    print(ServiceProvider.instance.screenService.isLandscape(context));

    return Container(
      height: ServiceProvider.instance.screenService
          .getHeightByPercentage(context, 30),
      width: ServiceProvider.instance.screenService.getWidth(context),
      color: ServiceProvider.instance.instanceStyleService.appStyle.mimiPink,
      child: Padding(
        padding: EdgeInsets.all(getDefaultPadding(context) * 4),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (controller.userInView.blocked) {
                  controller.user.blockedUserId
                      .remove(controller.userInView.id);
                  controller.userInView.blocked = false;
                  controller.user.docRef
                      .collection("blocked")
                      .document(controller.userInView.id)
                      .delete();
                } else {
                  controller.user.blockedUserId.add(controller.userInView.id);
                  controller.userInView.blocked = true;

                  controller.user.docRef
                      .collection("blocked")
                      .document(controller.userInView.id)
                      .setData({});
                }
                controller.onDone();
              },
              child: Container(
                width: ServiceProvider.instance.screenService
                    .getWidthByPercentage(context, 100),
                color: Colors.transparent,
                child: Row(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.ban,
                      color: ServiceProvider
                          .instance.instanceStyleService.appStyle.textGrey,
                      size: ServiceProvider.instance.instanceStyleService
                          .appStyle.iconSizeStandard,
                    ),
                    Container(
                      width: getDefaultPadding(context) * 4,
                    ),
                    Flexible(
                      child: Text(
                        controller.userInView.blocked
                            ? "Fjern blokkering av ${controller.userInView.name} "
                            : "Blokker ${controller.userInView.name}",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.body2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: getDefaultPadding(context) * 4,
            ),
            GestureDetector(
              onTap: () {
                Firestore.instance
                    .document("comment_reports/${controller.user.id}")
                    .setData({
                  "id": controller.comment.id,
                  "comment_by": controller.userInView.id,
                  "reported_by": controller.user.id,
                  "timestamp": DateTime.now(),
                });
                controller.onDone();
              },
              child: Container(
                width: ServiceProvider.instance.screenService
                    .getWidthByPercentage(context, 100),
                color: Colors.transparent,
                child: Row(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.solidFlag,
                      color: ServiceProvider
                          .instance.instanceStyleService.appStyle.textGrey,
                      size: ServiceProvider.instance.instanceStyleService
                          .appStyle.iconSizeStandard,
                    ),
                    Container(
                      width: getDefaultPadding(context) * 4,
                    ),
                    Text(
                      "Rapporter kommentar",
                      style: ServiceProvider
                          .instance.instanceStyleService.appStyle.body2,
                    ),
                  ],
                ),
              ),
            ),
            PrimaryButton(
              controller: PrimaryButtonController(
                  text: "Avbryt", onPressed: () => controller.onDone()),
            )
          ],
        ),
      ),
    );
  }
}
