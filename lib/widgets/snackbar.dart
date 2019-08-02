import 'package:bss/service/service_provider.dart';
import 'package:flutter/material.dart';

showSnackBar(String message, BuildContext context) {
  Scaffold.of(context).showSnackBar(new SnackBar(
      backgroundColor:
          ServiceProvider.instance.instanceStyleService.appStyle.caribbeanGreen,
      content: Container(
        height: ServiceProvider.instance.screenService
            .getHeightByPercentage(context, 10),
        child: Column(
          children: <Widget>[
            Text(
              message,
              textAlign: TextAlign.center,
              style: ServiceProvider
                  .instance.instanceStyleService.appStyle.body1Light,
            ),
          ],
        ),
      )));
}
