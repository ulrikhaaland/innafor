import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innafor/base_controller.dart';
import 'package:innafor/base_view.dart';
import 'package:innafor/service/service_provider.dart';

class FabController extends BaseController {
  bool showFab;

  final VoidCallback onPressed;

  FabController({this.showFab, this.onPressed});
}

class Fab extends BaseView {
  final FabController controller;

  Fab({this.controller});
  @override
  Widget build(BuildContext context) {
    if (controller.showFab)
      return FloatingActionButton(
        backgroundColor:
            ServiceProvider.instance.instanceStyleService.appStyle.leBleu,
        child: Icon(
          FontAwesomeIcons.solidComment,
          color: Colors.white,
          size: ServiceProvider
              .instance.instanceStyleService.appStyle.iconSizeStandard,
        ),
        onPressed: () => controller.onPressed(),
      );
    return Container();
  }
}
