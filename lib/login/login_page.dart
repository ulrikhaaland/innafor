import 'dart:async';
import 'package:bss/auth.dart';
import 'package:bss/helper.dart';
import 'package:bss/login/login_phone.dart';
import 'package:bss/service/service_provider.dart';
import 'package:bss/widgets/buttons/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../animation/show_up.dart';
import '../objects/user.dart';

enum SignInMethod { phone, email }

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.auth, this.user, this.userFound}) : super(key: key);

  final BaseAuth auth;
  FirebaseUser user;
  FirebaseUser get getUser => user;
  final VoidCallback userFound;
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // _verificationId = Provider.of<Auth>(context).getVerificationId;

    return Scaffold(
        backgroundColor: ServiceProvider
            .instance.instanceStyleService.appStyle.backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size(
              0,
              ServiceProvider.instance.screenService
                  .getPortraitHeightByPercentage(context, 20)),
          child: Center(
            child: Text(
              "Logg inn",
              style:
                  ServiceProvider.instance.instanceStyleService.appStyle.title,
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            PhoneLogin(
              controller: PhoneLoginController(
                auth: widget.auth,
                user: widget.user,
                userFound: null,
              ),
            ),
          ],
        ));
  }
}
