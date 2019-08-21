import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innafor/helper.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:flutter/material.dart';

showSnackBar(String message, BuildContext context) {
  Scaffold.of(context).showSnackBar(new SnackBar(
      backgroundColor:
          ServiceProvider.instance.instanceStyleService.appStyle.mimiPink,
      content: Container(
        height: ServiceProvider.instance.screenService
            .getHeightByPercentage(context, 12.5),
        width: ServiceProvider.instance.screenService.getWidth(context),
        child: Padding(
          padding: EdgeInsets.all(getDefaultPadding(context)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.body2,
                ),
                Container(
                  height: getDefaultPadding(context),
                ),
                GestureDetector(
                  onTap: () => print("GO TO BOOKMARKS"),
                  child: Icon(
                    FontAwesomeIcons.arrowRight,
                    color: ServiceProvider
                        .instance.instanceStyleService.appStyle.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      )));
}
