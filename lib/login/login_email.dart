import 'dart:async';

import 'package:innafor/base_controller.dart';
import 'package:innafor/base_view.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:innafor/widgets/buttons/primary_button.dart';
import 'package:innafor/widgets/textfield/primary_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../auth.dart';
import '../helper.dart';

class EmailLoginController extends BaseController {
  bool isLogin = true;

  final BaseAuth auth;

  PrimaryButtonController primaryButtonController;

  final VoidCallback returnUser;

  final formKey = GlobalKey<FormState>();

  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();

  String email;
  String password;
  String confirmPassword;

  String uid;

  String authHint = "";

  EmailLoginController({this.auth, this.returnUser});

  @override
  void initState() {
    primaryButtonController = PrimaryButtonController(
        text: "Bekreft",
        onPressed: () async {
          primaryButtonController.isLoading = true;
          primaryButtonController.refresh();
          await validateAndSave();
          primaryButtonController.isLoading = false;
          primaryButtonController.refresh();
        },
        color: ServiceProvider.instance.instanceStyleService.appStyle.imperial);

    super.initState();
  }

  Future<bool> validateAndSave() async {
    bool consensus = false;
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      uid = await loginOrRegister();
      if (uid == null) {
        consensus = false;
      } else {
        returnUser();
        consensus = true;
      }
    }
    return consensus;
  }

  Future<String> loginOrRegister() async {
    String userId;
    try {
      if (isLogin) {
        userId = await auth.signIn(email, password);
      } else {
        if (password == confirmPassword) {
          userId = await auth.createUser(email, password);
        } else {
          setAuthHint("Passordene stemmer ikke overens");
        }
      }
    } catch (e) {
      if (e.message ==
              "The password is invalid or the user does not have a password." ||
          e.message ==
              "There is no user record corresponding to this identifier. The user may have been deleted.") {
        authHint = "Feil email eller passord";
      } else if (e.message == "The email address is badly formatted.") {
        authHint = "Email-adressen er feil formatert";
      }
      setAuthHint(authHint);
      print(authHint);
    }
    return userId;
  }

  setAuthHint(String hintText) {
    authHint = hintText;
    refresh();
    Timer(Duration(seconds: 3), () {
      authHint = "";
      refresh();
    });
  }
}

class EmailLogin extends BaseView {
  final EmailLoginController controller;

  EmailLogin({this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ServiceProvider
              .instance.instanceStyleService.appStyle.backgroundColor,
          elevation: 0,
          title: Text(
            controller.isLogin ? "LOGG INN" : "REGISTRER",
            style: ServiceProvider
                .instance.instanceStyleService.appStyle.secondaryTitle,
          ),
          // bottom: PreferredSize(
          //     preferredSize: Size(0, 0),
          //     child: Divider(
          //       color: ServiceProvider
          //           .instance.instanceStyleService.appStyle.textGrey,
          //     )),
        ),
        backgroundColor: ServiceProvider
            .instance.instanceStyleService.appStyle.backgroundColor,
        body: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: <Widget>[
                Container(
                  height: getDefaultPadding(context) * 2,
                ),
                PrimaryTextField(
                  labelText: "Email",
                  focusNode: controller.emailNode,
                  textCapitalization: TextCapitalization.none,
                  textInputType: TextInputType.emailAddress,
                  onFieldSubmitted: () => fieldFocusChange(
                      context, controller.emailNode, controller.passwordNode),
                  onSaved: (val) => controller.email = val.trim().toLowerCase(),
                ),
                PrimaryTextField(
                  labelText: "Passord",
                  focusNode: controller.passwordNode,
                  obscure: true,
                  textCapitalization: TextCapitalization.none,
                  textInputAction:
                      controller.isLogin ? TextInputAction.done : null,
                  onFieldSubmitted: () => !controller.isLogin
                      ? fieldFocusChange(context, controller.passwordNode,
                          controller.confirmPasswordNode)
                      : null,
                  onSaved: (val) => controller.password = val,
                ),
                if (!controller.isLogin) ...[
                  PrimaryTextField(
                    labelText: "Bekreft passord",
                    focusNode: controller.confirmPasswordNode,
                    textCapitalization: TextCapitalization.none,
                    textInputAction: TextInputAction.done,
                    obscure: true,
                    onSaved: (val) => controller.confirmPassword = val,
                  ),
                ],
                PrimaryButton(
                  controller: controller.primaryButtonController,
                ),
                GestureDetector(
                  onTap: () {
                    controller.isLogin = !controller.isLogin;
                    controller.refresh();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: ServiceProvider.instance.screenService
                        .getWidthByPercentage(context, 50),
                    height: ServiceProvider.instance.screenService
                            .isLandscape(context)
                        ? ServiceProvider.instance.screenService
                            .getHeightByPercentage(context, 7.5)
                        : ServiceProvider.instance.screenService
                            .getHeightByPercentage(context, 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ServiceProvider.instance.instanceStyleService
                          .appStyle.mountbattenPink,
                    ),
                    child: Text(
                      controller.isLogin ? "Registrer deg" : "Logg inn",
                      style: ServiceProvider
                          .instance.instanceStyleService.appStyle.buttonText,
                    ),
                  ),
                ),
                Container(
                  height: getDefaultPadding(context) * 4,
                ),
                Container(
                  width: ServiceProvider.instance.screenService
                      .getWidthByPercentage(context, 90),
                  child: Text(
                    controller.authHint,
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.body1Black,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
