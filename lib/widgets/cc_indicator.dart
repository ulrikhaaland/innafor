import 'package:innafor/base_controller.dart';
import 'package:innafor/base_view.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class CCIndicatorController extends BaseController {
  int count;

  CCIndicatorController(this.count);
}

class CCIndicator extends BaseView {
  final CCIndicatorController controller;

  CCIndicator({this.controller});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Color.fromARGB(255, 122, 149, 241),
      radius: ServiceProvider.instance.screenService
          .getHeightByPercentage(context, 2),
      child: Center(
        child: Text(
          controller.count.toString(),
          style: TextStyle(
            fontSize: ServiceProvider.instance.screenService
                .getHeightByPercentage(context, 3),
            fontWeight: FontWeight.bold,
            color: ServiceProvider
                .instance.instanceStyleService.appStyle.backgroundColor,
          ),
        ),
      ),
    );
  }
}
