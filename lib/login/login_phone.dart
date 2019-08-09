import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:bss/service/service_provider.dart';
import 'package:bss/widgets/buttons/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth.dart';

enum SignInStatus { enterNumber, enterCode }

class PhoneLoginController extends BaseController {
  final BaseAuth auth;
  FirebaseUser user;

  PhoneLoginController({this.auth, this.userFound, this.user});
  FirebaseUser get getUser => user;
  final VoidCallback userFound;

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
            // await controller.auth.verifyPhoneNumber(
            //     "+47 " + controller.phoneNumber);
          } else {
            _isLoading = true;
            refresh();
            _formKey.currentState.save();
            user = await auth.signInWithPhone(_verificationId, _smsCode);
            dispose();
            userFound();
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _formKey.currentState.dispose();
    super.dispose();
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

    // Widget _label = Container(
    //   alignment: Alignment.center,
    //   height: ServiceProvider.instance.screenService
    //       .getPortraitHeightByPercentage(context, 7.15),
    //   child: GestureDetector(
    //       onTap: () {
    //         controller.signInStatus == SignInStatus.initialNumber
    //             ? controller.signInStatus = SignInStatus.enterNumber
    //             : controller.signInStatus = SignInStatus.enterCode;
    //         controller.refresh();
    //       },
    //       child: Text(
    //         controller._labelText,
    //         style: ServiceProvider.instance.instanceStyleService.appStyle.title,
    //       )),
    // );
    return Stack(
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
                    cursorColor: ServiceProvider
                        .instance.instanceStyleService.appStyle.imperial,
                    textAlign: TextAlign.center,
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.title,
                    autofocus: true,
                    // onEditingComplete: () => setState(() {
                    //       enterNumber = false;
                    //     }),
                    onFieldSubmitted: (s) {
                      if (s == null || s == "") {
                        print(s);
                        controller.signInStatus = SignInStatus.enterCode;
                        controller.refresh();
                      }
                    },
                    onSaved: (val) {
                      if (controller.signInStatus == SignInStatus.enterNumber) {
                        controller.phoneNumber = val;
                      } else if (controller.signInStatus ==
                          SignInStatus.enterCode) {
                        controller._smsCode = val;
                      }
                    },
                    decoration: InputDecoration(
                        hintStyle: ServiceProvider
                            .instance.instanceStyleService.appStyle.titleGrey,
                        hintText:
                            controller.signInStatus == SignInStatus.enterNumber
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
                        labelStyle: ServiceProvider.instance
                            .instanceStyleService.appStyle.textFieldLabel),
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

                PrimaryButton(controller: controller._btnCtrlr),
              ],
            )),
      ],
    );
  }
}
