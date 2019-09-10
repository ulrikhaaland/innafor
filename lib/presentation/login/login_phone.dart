import 'package:innafor/helper/auth.dart';
import 'package:innafor/helper/helper.dart';
import 'package:innafor/presentation/base_controller.dart';
import 'package:innafor/presentation/base_view.dart';
import 'package:innafor/presentation/widgets/buttons/primary_button.dart';
import 'package:innafor/root_page.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:flutter/material.dart';

enum SignInStatus { enterNumber, enterCode }

class PhoneLoginController extends BaseController {
  final BaseAuth auth;

  final formKey = GlobalKey<FormState>();

  String _smsCode = "";
  String _verificationId;

  SignInStatus signInStatus = SignInStatus.enterNumber;

  String phoneNumber = "";

  PrimaryButtonController _btnCtrlr;

  final RootPageController rootPageController;

  PhoneLoginController({
    this.auth,
    this.rootPageController,
  });

  @override
  void initState() {
    super.initState();
    _btnCtrlr = PrimaryButtonController(
      text: "Send meg engangskode på SMS",
      onPressed: () async {
        try {
          if (formKey.currentState.validate()) {
            if (signInStatus != SignInStatus.enterCode) {
              formKey.currentState.save();

              _btnCtrlr.isLoading = true;
              _btnCtrlr.setState(() {});
              _btnCtrlr.text = "Bekreft kode";

              formKey.currentState.save();

              await auth.verifyPhoneNumber(
                  phoneNumber: "+47 " + phoneNumber,
                  theId: (s) {
                    _verificationId = s;
                    signInStatus = SignInStatus.enterCode;

                    _btnCtrlr.isLoading = false;
                    _btnCtrlr.setState(() {});
                    setState(() {});
                  });
            } else {
              _btnCtrlr.isLoading = true;
              _btnCtrlr.setState(() {});
              setState(() {});
              formKey.currentState.save();
              rootPageController.firebaseUser =
                  await auth.signInWithPhone(_verificationId, _smsCode);
              if (rootPageController.firebaseUser != null) {
                rootPageController.getUser().then((v) {
                  Navigator.pop(context);
                });
              } else {
                signInStatus = SignInStatus.enterNumber;
                setState(() {});
              }
              _btnCtrlr.isLoading = false;
              _btnCtrlr.setState(() {});
            }
          }
        } catch (e) {
          _btnCtrlr.isLoading = false;
          _btnCtrlr.setState(() {});
          signInStatus = SignInStatus.enterNumber;
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    formKey.currentState.dispose();
    super.dispose();
  }
}

class PhoneLogin extends BaseView {
  final PhoneLoginController controller;

  PhoneLogin({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
        body: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: <Widget>[
                Container(
                  height: getDefaultPadding(context) * 2,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: ServiceProvider.instance.screenService
                          .getWidthByPercentage(context, 15),
                      right: ServiceProvider.instance.screenService
                          .getWidthByPercentage(context, 15)),
                  child: controller.signInStatus == SignInStatus.enterNumber
                      ? TextFormField(
                          key: Key("number"),
                          initialValue: controller.phoneNumber,
                          keyboardType: TextInputType.phone,
                          cursorColor: ServiceProvider
                              .instance.instanceStyleService.appStyle.imperial,
                          textAlign: TextAlign.center,
                          style: ServiceProvider.instance.instanceStyleService
                              .appStyle.secondaryTitle,
                          autofocus: true,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Vennligst skriv inn hele nummeret";
                            }
                          },
                          onSaved: (val) => controller.phoneNumber = val.trim(),
                          decoration: InputDecoration(
                              hintStyle: ServiceProvider.instance
                                  .instanceStyleService.appStyle.titleGrey,
                              hintText: "Telefonnummer",
                              counterStyle: TextStyle(
                                  color: Colors.red, fontFamily: "Montserrat"),
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
                        )
                      : TextFormField(
                          key: Key("code"),
                          initialValue: controller._smsCode,
                          keyboardType: TextInputType.number,
                          cursorColor: ServiceProvider
                              .instance.instanceStyleService.appStyle.imperial,
                          textAlign: TextAlign.center,
                          style: ServiceProvider.instance.instanceStyleService
                              .appStyle.secondaryTitle,
                          autofocus: true,
                          validator: (val) {
                            if (val.length > 6) {
                              return "Vennligst skriv inn den 6-sifrede koden";
                            }
                          },
                          onSaved: (val) => controller._smsCode = val,
                          decoration: InputDecoration(
                              hintStyle: ServiceProvider.instance
                                  .instanceStyleService.appStyle.titleGrey,
                              hintText: "Engangskode",
                              counterStyle: TextStyle(
                                  color: Colors.red, fontFamily: "Montserrat"),
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
                PrimaryButton(
                  controller: controller._btnCtrlr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
