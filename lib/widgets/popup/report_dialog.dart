import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innafor/base_controller.dart';
import 'package:innafor/base_view.dart';
import 'package:innafor/helper.dart';
import 'package:innafor/objects/comment.dart';
import 'package:innafor/objects/report_dialog_info.dart';
import 'package:innafor/objects/user.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:innafor/widgets/buttons/primary_button.dart';
import 'package:provider/provider.dart';

class ReportDialogController extends BaseController {
  final VoidCallback onDone;

  final ReportDialogInfo reportDialogInfo;

  ReportDialogController({this.onDone, this.reportDialogInfo});
}

class ReportDialog extends BaseView {
  final ReportDialogController controller;

  ReportDialog({this.controller});
  @override
  Widget build(BuildContext context) {
    controller.reportDialogInfo.reportedUser.blocked = controller
        .reportDialogInfo.reportedByUser.blockedUserId
        .contains(controller.reportDialogInfo.reportedUser.id);

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
                if (controller.reportDialogInfo.reportedUser.blocked) {
                  controller.reportDialogInfo.reportedByUser.blockedUserId
                      .remove(controller.reportDialogInfo.reportedUser.id);
                  controller.reportDialogInfo.reportedByUser.docRef
                      .collection("blocked")
                      .document(controller.reportDialogInfo.reportedUser.id)
                      .delete();
                } else {
                  controller.reportDialogInfo.reportedByUser.blockedUserId
                      .add(controller.reportDialogInfo.reportedUser.id);

                  controller.reportDialogInfo.reportedByUser.docRef
                      .collection("blocked")
                      .document(controller.reportDialogInfo.reportedUser.id)
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
                        controller.reportDialogInfo.reportedUser.blocked
                            ? "Fjern blokkering av ${controller.reportDialogInfo.reportedUser.name ?? "N/A"} "
                            : "Blokker ${controller.reportDialogInfo.reportedUser.name ?? "N/A"}",
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
                controller.reportDialogInfo.pushReport();
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
                      controller.reportDialogInfo.typeString == "post"
                          ? "Rapporter innlegg"
                          : "Rapporter kommentar",
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
