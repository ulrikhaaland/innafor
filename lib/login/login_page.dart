import 'dart:async';
import 'package:bss/auth.dart';
import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:bss/helper.dart';
import 'package:bss/login/login_email.dart';
import 'package:bss/login/login_phone.dart';
import 'package:bss/root_page.dart';
import 'package:bss/service/service_provider.dart';
import 'package:bss/widgets/buttons/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../animation/show_up.dart';
import '../objects/user.dart';

// enum SignIn { chooseMethod, phone, email }

class LoginPageController extends BaseController {
  // SignIn signIn = SignIn.chooseMethod;

  final BaseAuth auth;

  FirebaseUser user;

  final RootPageController rootPageController;

  final void Function(FirebaseUser user) returnUser;

  LoginPageController(
      {this.auth, this.returnUser, this.user, this.rootPageController});
}

class LoginPage extends BaseView {
  final LoginPageController controller;

  LoginPage({this.controller});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ServiceProvider
              .instance.instanceStyleService.appStyle.backgroundColor,
          elevation: 0,
        ),
        backgroundColor: ServiceProvider
            .instance.instanceStyleService.appStyle.backgroundColor,
        body: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "LOGG INN",
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.secondaryTitle,
                ),
                Text(
                  "ELLER",
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.secondaryTitle,
                ),
                Text(
                  "REGISTRER DEG",
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.secondaryTitle,
                ),
                Text(
                  "MED",
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.secondaryTitle,
                ),
                Container(
                  height: ServiceProvider.instance.screenService
                      .getHeightByPercentage(context, 5),
                  width: 1,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PhoneLogin(
                                controller: PhoneLoginController(
                                  auth: controller.auth,
                                  returnUser: (user) =>
                                      controller.returnUser(user),
                                ),
                              )),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: ServiceProvider
                            .instance.instanceStyleService.appStyle.imperial,
                        borderRadius: BorderRadius.circular(8)),
                    height: ServiceProvider.instance.screenService
                        .getPortraitHeightByPercentage(context, 7.5),
                    width: ServiceProvider.instance.screenService
                        .getWidthByPercentage(context, 70),
                    child: Center(
                      child: Text(
                        "Telefon",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.buttonText,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: ServiceProvider.instance.screenService
                      .getHeightByPercentage(context, 5),
                  width: 1,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmailLogin(
                                controller: EmailLoginController(
                                    auth: controller.auth,
                                    returnUser: () async {
                                      await controller.rootPageController
                                          .getUser();
                                      Navigator.of(context).pop();
                                    }),
                              )),
                    );
                  },
                  child: Container(
                    height: ServiceProvider.instance.screenService
                        .getPortraitHeightByPercentage(context, 7.5),
                    width: ServiceProvider.instance.screenService
                        .getWidthByPercentage(context, 70),
                    decoration: BoxDecoration(
                        color: ServiceProvider.instance.instanceStyleService
                            .appStyle.mountbattenPink,
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(
                        "Email",
                        style: ServiceProvider
                            .instance.instanceStyleService.appStyle.buttonText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: getDefaultPadding(context) * 4,
            ),
          ],
        ));
  }
}
