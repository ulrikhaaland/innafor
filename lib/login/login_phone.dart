import 'package:innafor/base_controller.dart';
import 'package:innafor/base_view.dart';
import 'package:innafor/objects/user.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:innafor/widgets/buttons/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth.dart';
import '../helper.dart';

enum SignInStatus { enterNumber, enterCode }

class PhoneLoginController extends BaseController {
  final BaseAuth auth;

  PhoneLoginController({
    this.auth,
    this.returnUser,
  });
  final void Function(FirebaseUser user) returnUser;

  FirebaseUser user;

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _smsCode;
  String _verificationId;
  String _labelText = "Ditt telefonnummer";

  SignInStatus signInStatus = SignInStatus.enterNumber;

  String phoneNumber;

  PrimaryButtonController _btnCtrlr;

  @override
  void initState() {
    super.initState();
    _btnCtrlr = PrimaryButtonController(
      text: signInStatus == SignInStatus.enterNumber
          ? "Send meg engangskode på SMS"
          : "Bekreft",
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          if (signInStatus != SignInStatus.enterCode) {
            _btnCtrlr.isLoading = !_btnCtrlr.isLoading;
            _btnCtrlr.refresh();
            _isLoading = true;
            refresh();
            _labelText = "Skriv inn koden";

            _formKey.currentState.save();
            await auth.verifyPhoneNumber("+47 " + phoneNumber).catchError((e) {
              signInStatus = SignInStatus.enterNumber;
              refresh();
            });
            signInStatus = SignInStatus.enterCode;
            refresh();
          } else {
            _isLoading = true;
            refresh();
            _formKey.currentState.save();
            user = await auth.signInWithPhone(_verificationId, _smsCode);
            dispose();
            returnUser(user);
          }
        }
      },
    );
  }
}

class PhoneLogin extends BaseView {
  final PhoneLoginController controller;

  PhoneLogin({this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller._verificationId != null) {
      controller._isLoading = false;
      controller.refresh();
      if (controller.signInStatus != SignInStatus.enterCode) {
        controller.signInStatus = SignInStatus.enterCode;
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ServiceProvider
              .instance.instanceStyleService.appStyle.backgroundColor,
          elevation: 0,
          title: Text(
            "LOGG INN",
            style: ServiceProvider
                .instance.instanceStyleService.appStyle.secondaryTitle,
          ),
        ),
        backgroundColor: ServiceProvider
            .instance.instanceStyleService.appStyle.backgroundColor,
        body: Column(
          children: <Widget>[
            Container(
              height: getDefaultPadding(context) * 2,
            ),
            Stack(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                      top: ServiceProvider.instance.screenService
                          .getPortraitHeightByPercentage(context, 0),
                    ),
                    child: Column(
                      children: <Widget>[
                        // if (controller.signInStatus == SignInStatus.enterNumber ||
                        //     controller.signInStatus == SignInStatus.enterCode) ...[
                        Form(
                          key: controller._formKey,
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            cursorColor: ServiceProvider.instance
                                .instanceStyleService.appStyle.imperial,
                            textAlign: TextAlign.center,
                            style: ServiceProvider.instance.instanceStyleService
                                .appStyle.secondaryTitle,
                            autofocus: true,
                            // onEditingComplete: () => setState(() {
                            //       enterNumber = false;
                            //     }),
                            onFieldSubmitted: (s) {
                              if (s == null || s == "") {
                                print(s);
                                controller.signInStatus =
                                    SignInStatus.enterCode;
                                controller.refresh();
                              }
                            },
                            onSaved: (val) {
                              if (controller.signInStatus ==
                                  SignInStatus.enterNumber) {
                                controller.phoneNumber = val;
                              } else if (controller.signInStatus ==
                                  SignInStatus.enterCode) {
                                controller._smsCode = val;
                              }
                            },
                            decoration: InputDecoration(
                                hintStyle: ServiceProvider.instance
                                    .instanceStyleService.appStyle.titleGrey,
                                hintText: controller.signInStatus ==
                                        SignInStatus.enterNumber
                                    ? "Telefonnummer"
                                    : "Engangskode",
                                counterStyle: TextStyle(color: Colors.red),
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
                                    .instance
                                    .instanceStyleService
                                    .appStyle
                                    .textFieldLabel),
                          ),
                        ),
                        // ],
                        // else if (controller.signInStatus ==
                        //     SignInStatus.initialNumber) ...[
                        //   _label,
                        // ] else if (controller.signInStatus ==
                        //     SignInStatus.initialCode) ...[
                        //   _label,
                        // ],

                        PrimaryButton(
                          controller: controller._btnCtrlr,
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
