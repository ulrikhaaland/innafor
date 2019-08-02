import 'dart:async';
import 'package:bss/auth.dart';
import 'package:bss/helper.dart';
import 'package:bss/service/service_provider.dart';
import 'package:bss/widgets/buttons/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../animation/show_up.dart';
import '../objects/user.dart';

enum SignInStatus { enterNumber, enterCode, initialNumber, initialCode }

class LoginPage extends StatefulWidget with ChangeNotifier {
  LoginPage({Key key, this.auth, this.user, this.userFound}) : super(key: key);

  final BaseAuth auth;
  FirebaseUser user;
  FirebaseUser get getUser => user;
  final VoidCallback userFound;
  _LoginPageState createState() => _LoginPageState();

  @override
  void dispose() {
    ChangeNotifier().dispose();
    super.dispose();
  }
}

class _LoginPageState extends State<LoginPage> with ChangeNotifier {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _smsCode;
  String _verificationId;
  String _labelText = "Ditt telefonnummer";

  SignInStatus signInStatus = SignInStatus.initialNumber;

  String phoneNumber;

  @override
  void dispose() {
    _formKey.currentState.dispose();
    ChangeNotifier().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _verificationId = Provider.of<Auth>(context).getVerificationId;

    if (_verificationId != null) {
      setState(() {});
      _isLoading = false;
      if (signInStatus != SignInStatus.enterCode) {
        signInStatus = SignInStatus.initialCode;
      }
    }

    Widget label = Container(
      alignment: Alignment.center,
      height: ServiceProvider.instance.screenService
          .getPortraitHeightByPercentage(context, 7.15),
      child: GestureDetector(
          onTap: () {
            setState(() {
              signInStatus == SignInStatus.initialNumber
                  ? signInStatus = SignInStatus.enterNumber
                  : signInStatus = SignInStatus.enterCode;
            });
          },
          child: Text(
            _labelText,
            style: ServiceProvider.instance.instanceStyleService.appStyle.title,
          )),
    );

    return Scaffold(
        backgroundColor: ServiceProvider
            .instance.instanceStyleService.appStyle.caribbeanGreen,
        appBar: PreferredSize(
          preferredSize: Size(
              0,
              ServiceProvider.instance.screenService
                  .getPortraitHeightByPercentage(context, 20)),
          child: Center(
            child: Text(
              "LOGG INN",
              style:
                  ServiceProvider.instance.instanceStyleService.appStyle.title,
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(
                  top: ServiceProvider.instance.screenService
                      .getPortraitHeightByPercentage(context, 5),
                ),
                child: Column(
                  children: <Widget>[
                    if (signInStatus == SignInStatus.enterNumber ||
                        signInStatus == SignInStatus.enterCode) ...[
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          cursorColor: ServiceProvider
                              .instance.instanceStyleService.appStyle.sunGlow,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: ServiceProvider.instance.screenService
                                    .getPortraitHeightByPercentage(
                                        context, 100) *
                                0.040,
                            color: ServiceProvider.instance.instanceStyleService
                                .appStyle.lightYellow,
                          ),
                          autofocus: true,
                          // onEditingComplete: () => setState(() {
                          //       enterNumber = false;
                          //     }),
                          onFieldSubmitted: (s) {
                            if (s == null || s == "") {
                              print(s);
                              setState(() {
                                signInStatus = SignInStatus.initialCode;
                              });
                            }
                          },
                          onSaved: (val) {
                            if (signInStatus == SignInStatus.enterNumber) {
                              phoneNumber = val;
                            } else if (signInStatus == SignInStatus.enterCode) {
                              _smsCode = val;
                            }
                          },
                          decoration: InputDecoration(
                              hintText: signInStatus == SignInStatus.enterNumber
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
                    ] else if (signInStatus == SignInStatus.initialNumber) ...[
                      label,
                    ] else if (signInStatus == SignInStatus.initialCode) ...[
                      label,
                    ],
                    if (signInStatus == SignInStatus.initialCode ||
                        signInStatus == SignInStatus.enterCode) ...[
                      PrimaryButton(
                        controller: PrimaryButtonController(
                          text: "Bekreft",
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              _formKey.currentState.save();
                              widget.user = await widget.auth
                                  .signInWithPhone(_verificationId, _smsCode);
                              widget.notifyListeners();
                              dispose();
                              widget.userFound();
                            }
                          },
                        ),
                      ),
                    ],
                    if (signInStatus != SignInStatus.enterCode &&
                        signInStatus != SignInStatus.initialCode) ...[
                      PrimaryButton(
                        controller: PrimaryButtonController(
                          text: "Send meg engangskode på SMS",
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              _labelText = "Skriv inn koden";

                              _formKey.currentState.save();

                              await widget.auth
                                  .verifyPhoneNumber("+47 " + phoneNumber);
                            }
                          },
                        ),
                      ),
                    ]
                  ],
                )),
            if (_isLoading) ...[
              Center(
                child: CircularProgressIndicator(
                  backgroundColor: ServiceProvider
                      .instance.instanceStyleService.appStyle.sunGlow,
                  valueColor: AlwaysStoppedAnimation<Color>(ServiceProvider
                      .instance.instanceStyleService.appStyle.lightYellow),
                ),
              ),
            ],
          ],
        ));
  }
}
