import 'package:bss/auth.dart';
import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/service_provider.dart';
import '../helper.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

class HomePageController extends BaseController {
  final BaseAuth auth;

  final searchText = new ValueNotifier<String>("");

  HomePageController({this.auth});
  @override
  void initState() {
    super.initState();
  }
}

class HomePage extends BaseView {
  final HomePageController controller;

  HomePage({
    this.controller,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: FancyBottomNavigation(
      //   barBackgroundColor: ServiceProvider
      //       .instance.instanceStyleService.appStyle.caribbeanGreen,
      //   activeIconColor:
      //       ServiceProvider.instance.instanceStyleService.appStyle.sunGlow,
      //   inactiveIconColor:
      //       ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
      //   circleColor:
      //       ServiceProvider.instance.instanceStyleService.appStyle.lightYellow,
      //   textColor: Colors.white,
      //   tabs: [
      //     TabData(iconData: Icons.home, title: "Henvend"),
      //     TabData(iconData: Icons.message, title: "Samtaler"),
      //     TabData(iconData: Icons.person, title: "Profil"),
      //   ],
      //   onTabChangedListener: (position) {
      //     // setState(() {
      //     // currentPage = position;
      //     // });
      //   },
      // ),
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(
            0,
            ServiceProvider.instance.screenService
                .getHeightByPercentage(context, 15)),
        child: Padding(
          padding: EdgeInsets.only(
              top: ServiceProvider.instance.screenService
                  .getHeightByPercentage(context, 5)),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      iconSize: ServiceProvider
                          .instance.instanceStyleService.appStyle.iconSizeBig,
                      icon: Icon(
                        Icons.person,
                        color: ServiceProvider.instance.instanceStyleService
                            .appStyle.activeIconColor,
                      ),
                      onPressed: () => controller.auth.signOut()),
                  IconButton(
                      iconSize: ServiceProvider
                          .instance.instanceStyleService.appStyle.iconSizeBig,
                      icon: Icon(
                        Icons.message,
                        color: ServiceProvider.instance.instanceStyleService
                            .appStyle.activeIconColor,
                      ),
                      onPressed: () => controller.auth.signOut())
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: TextField(
              keyboardType: TextInputType.text,
              cursorColor: ServiceProvider
                  .instance.instanceStyleService.appStyle.sunGlow,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: ServiceProvider.instance.screenService
                          .getHeightByPercentage(context, 100) *
                      0.040,
                  color: ServiceProvider
                      .instance.instanceStyleService.appStyle.textGrey),
              autofocus: true,
              onChanged: (val) {
                controller.searchText.value = val;
              },
              decoration: InputDecoration(
                  hintText: "SØK",
                  enabledBorder: new UnderlineInputBorder(
                      borderSide: new BorderSide(
                    style: BorderStyle.none,
                  )),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.none,
                    ),
                  ),
                  labelStyle: ServiceProvider
                      .instance.instanceStyleService.appStyle.textFieldLabel),
            ),
          ),
        ],
      ),
    );
  }
}
